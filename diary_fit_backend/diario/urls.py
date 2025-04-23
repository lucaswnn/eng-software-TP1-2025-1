from django.urls import path, include
from .views import AnamneseViewSet
from rest_framework.routers import DefaultRouter
from .views import (
    SignupView,
    PesoViewSet,
    RefeicaoViewSet,
    ExercicioViewSet,
    CalendarioDiarioView,
    AnamneseViewSet,
    AlimentoViewSet, 
    CardapioViewSet
)

router = DefaultRouter()
router.register(r'pesos', PesoViewSet, basename='pesos')
router.register(r'refeicoes', RefeicaoViewSet, basename='refeicoes')
router.register(r'exercicios', ExercicioViewSet, basename='exercicios')
router.register(r'anamnese', AnamneseViewSet, basename='anamnese')
router.register(r'alimentos', AlimentoViewSet, basename='alimentos')
router.register(r'cardapios', CardapioViewSet, basename='cardapios')

urlpatterns = [
    path('', include(router.urls)),
    path('signup/', SignupView.as_view(), name='signup'),
    path('calendario/', CalendarioDiarioView.as_view(), name='calendario'),
]
