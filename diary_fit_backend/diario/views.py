from rest_framework import viewsets, permissions, status
from rest_framework.views import APIView
from rest_framework.response import Response
from collections import defaultdict
from rest_framework_simplejwt.views import TokenObtainPairView
from .serializers import MyTokenObtainPairSerializer
from rest_framework.exceptions import PermissionDenied

class MyTokenObtainPairView(TokenObtainPairView):
    serializer_class = MyTokenObtainPairSerializer

from .models import (
    Peso,
    Refeicao,
    Exercicio,
    VinculoProfissionalPaciente,
    Anamnese,
    Cardapio,
    Ficha,
)

from .serializers import (
    PesoSerializer,
    RefeicaoSerializer,
    ExercicioSerializer,
    UserSerializer,
    VinculoSerializer,
    AnamneseSerializer,
    CardapioSerializer,
    FichaSerializer,
)

# ——————————
# Cadastro de Usuário
# ——————————
class SignupView(APIView):
    """
    Endpoint: POST /api/signup/
    Corpo JSON: { "username": "...", "password": "...", "tipo": "paciente" }
    """
    def post(self, request):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({'message': 'Usuário criado!'},
                            status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# ——————————
# ViewSets de CRUD
# ——————————
class PesoViewSet(viewsets.ModelViewSet):
    queryset = Peso.objects.all()
    serializer_class = PesoSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        # só retorna os pesos do usuário logado
        user = self.request.user
        tipo = user.perfil.tipo
        
        if tipo == 'paciente':
            # paciente só vê os próprios pesos
            return Peso.objects.filter(usuario=user)
        elif tipo in ['nutricionista', 'educador_fisico']:
            pacientes_ids = VinculoProfissionalPaciente.objects.filter(
                profissional=user
            ).values_list('paciente', flat=True)
            # nutricionista/educador vê os pesos dos pacientes vinculados
            return Peso.objects.filter(usuario__in=pacientes_ids)
        
        return Peso.objects.none()

    def perform_create(self, serializer):
        user = self.request.user
        if user.perfil.tipo != 'paciente':
            # só paciente pode criar peso
            raise PermissionDenied("Somente pacientes podem criar pesos.")
        
        # vincula o registro ao usuário logado
        serializer.save(usuario=user)


class RefeicaoViewSet(viewsets.ModelViewSet):
    """
    Se for paciente, lista/exibe só as refeições que o próprio paciente fez.
    Se for nutricionista, lista/exibe só as refeições que ele criou (nutricionista).
    """
    serializer_class = RefeicaoSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        tp = user.perfil.tipo

        if tp == 'paciente':
            # registros feitos pelo próprio paciente
            return Refeicao.objects.filter(usuario=user)
        elif tp == 'nutricionista':
            pacientes_ids = VinculoProfissionalPaciente.objects.filter(
                profissional=user
            ).values_list('paciente', flat=True)
            # nutricionista vê as refeições dos pacientes vinculados
            return Refeicao.objects.filter(usuario__in=pacientes_ids)
        
        return Refeicao.objects.none()

    def perform_create(self, serializer):
        user = self.request.user
        if user.perfil.tipo != 'paciente':
            raise PermissionDenied("Somente pacientes podem criar refeições.")
        
        serializer.save(usuario=user)


class ExercicioViewSet(viewsets.ModelViewSet):
    """
    Se for paciente, lista/exibe só os exercícios que o próprio paciente fez.
    Se for educador físico, lista/exibe só os exercícios que ele criou (treinador).
    """
    serializer_class = ExercicioSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        tp = user.perfil.tipo
        if tp == 'paciente':
            # registros feitos pelo próprio paciente
            return Exercicio.objects.filter(usuario=user)
        elif tp == 'educador_fisico':
            pacientes_ids = VinculoProfissionalPaciente.objects.filter(
                profissional=user
            ).values_list('paciente', flat=True)
            # treinador vê os exercícios dos pacientes vinculados
            return Exercicio.objects.filter(usuario__in=pacientes_ids)
        else:
            raise PermissionDenied("Acesso concedido somente para treinadores.")

    def perform_create(self, serializer):
        user = self.request.user
        if user.perfil.tipo != 'paciente':
            raise PermissionDenied("Somente pacientes podem criar exercicios.")
        
        serializer.save(usuario=user)

# ——————————
# Calendário Diário
# ——————————
class CalendarioDiarioView(APIView):
    """
    Endpoint: GET /api/calendario/
    Retorna todos os registros de refeição e exercício agrupados por data.
    """
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        dados = defaultdict(lambda: {"refeicoes": [], "exercicios": []})
        # coleta todas as refeicoes e exercicios do usuário
        for r in Refeicao.objects.filter(usuario=request.user):
            dia = r.data.isoformat()
            dados[dia]["refeicoes"].append(RefeicaoSerializer(r).data)
        for e in Exercicio.objects.filter(usuario=request.user):
            dia = e.data.isoformat()
            dados[dia]["exercicios"].append(ExercicioSerializer(e).data)
        return Response(dados)

class AnamneseViewSet(viewsets.ModelViewSet):
    """
    CRUD de Anamnese. 
    Cada paciente só vê e edita sua própria ficha.
    """
    queryset = Anamnese.objects.all()
    serializer_class = AnamneseSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        # só retorna anamnese do usuário logado
        user = self.request.user
        tipo = user.perfil.tipo
        
        if tipo == 'paciente':
            # paciente só vê a própria ficha anamnese
            return Anamnese.objects.filter(usuario=user)
        elif tipo in ['nutricionista', 'educador_fisico']:
            pacientes_ids = VinculoProfissionalPaciente.objects.filter(
                profissional=user
            ).values_list('paciente', flat=True)
            # nutricionista/educador vê as fichas anamnese dos pacientes vinculados
            return Anamnese.objects.filter(usuario__in=pacientes_ids)
        
        return Anamnese.objects.none()

    def perform_create(self, serializer):
        user = self.request.user
        if user.perfil.tipo != 'paciente':
            # só paciente pode criar peso
            raise PermissionDenied("Somente pacientes podem criar fichas anamnese.")
        
        # vincula o registro ao usuário logado
        serializer.save(usuario=user)

class CardapioViewSet(viewsets.ModelViewSet):
    """
    Se for paciente, lista só os cardápios destinados a ele.
    Se for nutricionista, lista só os cardápios que ele criou.
    """
    serializer_class = CardapioSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        tp = user.perfil.tipo
        if tp == 'paciente':
            return Cardapio.objects.filter(paciente=user)
        elif tp == 'nutricionista':
            pacientes_ids = VinculoProfissionalPaciente.objects.filter(
                profissional=user
            ).values_list('paciente_id', flat=True)
            # nutricionista vê os cardápios dos pacientes vinculados
            return Cardapio.objects.filter(paciente__in=pacientes_ids)
        else:
            raise PermissionDenied("Acesso somente para nutricionistas.")

    def perform_create(self, serializer):
        # somente nutricionista cria cardápio
        user = self.request.user
        tp = user.perfil.tipo
        if tp != 'nutricionista':
            raise PermissionDenied("Apenas nutricionistas podem criar cardápios.")
        
        serializer.save(paciente=self.request.user)

class VinculoViewSet(viewsets.ModelViewSet):
    """
    Nutricionista/Educador vê só seus vínculos.
    Paciente vê só os seus.
    """
    serializer_class = VinculoSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        tp = user.perfil.tipo
        if tp in ['nutricionista', 'educador_fisico']:
            return VinculoProfissionalPaciente.objects.filter(profissional=user)
        if tp == 'paciente':
            return VinculoProfissionalPaciente.objects.filter(paciente=user)
        return VinculoProfissionalPaciente.objects.none()

    def perform_create(self, serializer):
        # só profissionais podem criar
        user = self.request.user
        if user.perfil.tipo not in ['nutricionista', 'educador_fisico']:
            raise PermissionDenied("Somente nutricionistas ou educadores físicos podem criar vínculos.")
        
        serializer.save(profissional=user)

class FichaViewSet(viewsets.ModelViewSet):
    """
    Educador vê só suas fichas.
    Paciente vê só as suas.
    """
    serializer_class = FichaSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        tp = user.perfil.tipo
        if tp == 'paciente':
            return Ficha.objects.filter(usuario=user)
        elif tp == 'educador_fisico':
            usuarios_ids = VinculoProfissionalPaciente.objects.filter(
                profissional=user
            ).values_list('paciente_id', flat=True)
            # nutricionista vê os cardápios dos pacientes vinculados
            return Ficha.objects.filter(usuario__in=usuarios_ids)
        else:
            raise PermissionDenied("Acesso somente para treinadores.")

    def perform_create(self, serializer):
        # somente nutricionista cria cardápio
        user = self.request.user
        tp = user.perfil.tipo
        if tp != 'educador_fisico':
            raise PermissionDenied("Apenas treinadores podem criar fichas.")
        
        serializer.save(usuario=self.request.user)