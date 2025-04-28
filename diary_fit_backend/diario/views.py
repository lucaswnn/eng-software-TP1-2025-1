from rest_framework import viewsets, permissions, status
from rest_framework.views import APIView
from rest_framework.response import Response
from collections import defaultdict
from rest_framework_simplejwt.views import TokenObtainPairView
from .serializers import MyTokenObtainPairSerializer
from .models import VinculoProfissionalPaciente
from .serializers import VinculoSerializer

class MyTokenObtainPairView(TokenObtainPairView):
    serializer_class = MyTokenObtainPairSerializer

from .models import Perfil, Peso, Refeicao, Exercicio
from .serializers import (
    PerfilSerializer,
    PesoSerializer,
    RefeicaoSerializer,
    ExercicioSerializer,
    UserSerializer,
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
        return Peso.objects.filter(usuario=self.request.user)

    def perform_create(self, serializer):
        # vincula o registro ao usuário logado
        serializer.save(usuario=self.request.user)


class RefeicaoViewSet(viewsets.ModelViewSet):
    queryset = Refeicao.objects.all()
    serializer_class = RefeicaoSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Refeicao.objects.filter(usuario=self.request.user)

    def perform_create(self, serializer):
        serializer.save(usuario=self.request.user)


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
            # registros criados por este treinador
            return Exercicio.objects.filter(treinador=user)
        return Exercicio.objects.none()

    def perform_create(self, serializer):
        user = self.request.user
        if user.perfil.tipo == 'paciente':
            # paciente registra o próprio exercício
            serializer.save(usuario=user)
        else:
            # educador físico registra exercício para um paciente
            # precisa passar "usuario" no JSON para indicar o cliente
            serializer.save(treinador=user)

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


from .models import Anamnese
from .serializers import AnamneseSerializer

class AnamneseViewSet(viewsets.ModelViewSet):
    """
    CRUD de Anamnese. 
    Cada paciente só vê e edita sua própria ficha.
    """
    queryset = Anamnese.objects.all()
    serializer_class = AnamneseSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        # retorna apenas a ficha do usuário logado (ou vazia)
        return Anamnese.objects.filter(usuario=self.request.user)

    def perform_create(self, serializer):
        # vincula ao usuário logado
        serializer.save(usuario=self.request.user)

from .models import Alimento, Cardapio
from .serializers import AlimentoSerializer, CardapioSerializer

class AlimentoViewSet(viewsets.ModelViewSet):
    """
    CRUD de Alimentos – só nutricionistas/criadores precisam chamar.
    """
    queryset = Alimento.objects.all()
    serializer_class = AlimentoSerializer
    permission_classes = [permissions.IsAuthenticated]  # você pode criar um custom IsNutricionista

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
            return Cardapio.objects.filter(nutricionista=user)
        return Cardapio.objects.none()

    def perform_create(self, serializer):
        # somente nutricionista cria cardápio
        serializer.save(nutricionista=self.request.user)


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
        serializer.save(profissional=self.request.user)