from django.urls import path, include
from rest_framework.routers import DefaultRouter

from .views import (
    SignupView,
    PesoViewSet,
    RefeicaoViewSet,
    ExercicioViewSet,
    CalendarioDiarioView,
    AnamneseViewSet,
    CardapioViewSet,
    VinculoViewSet,
    FichaViewSet,
)

router = DefaultRouter()
router.register(r'pesos', PesoViewSet, basename='pesos')
router.register(r'refeicoes', RefeicaoViewSet, basename='refeicoes')
router.register(r'exercicios', ExercicioViewSet, basename='exercicios')
router.register(r'anamnese', AnamneseViewSet, basename='anamnese')
router.register(r'cardapios', CardapioViewSet, basename='cardapios')
router.register(r'vinculos', VinculoViewSet, basename='vinculos')
router.register(r'fichas', FichaViewSet, basename='fichas')

urlpatterns = [
    path('', include(router.urls)),
    path('signup/', SignupView.as_view(), name='signup'),
    path('calendario/', CalendarioDiarioView.as_view(), name='calendario'),
]
