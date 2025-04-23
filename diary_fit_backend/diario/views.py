from rest_framework import viewsets, permissions, status
from rest_framework.views import APIView
from rest_framework.response import Response
from collections import defaultdict

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
    queryset = Exercicio.objects.all()
    serializer_class = ExercicioSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Exercicio.objects.filter(usuario=self.request.user)

    def perform_create(self, serializer):
        serializer.save(usuario=self.request.user)


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
    CRUD de Cardápios – ligados a pacientes.
    """
    queryset = Cardapio.objects.all()
    serializer_class = CardapioSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        # nutricionista vê todos; paciente só vê o próprio
        if user.perfil.tipo == 'paciente':
            return Cardapio.objects.filter(paciente=user)
        return super().get_queryset()
