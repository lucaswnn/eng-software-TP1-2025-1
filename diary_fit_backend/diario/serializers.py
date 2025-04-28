from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Perfil, Peso, Refeicao, Exercicio, Anamnese,Alimento, Cardapio


class PerfilSerializer(serializers.ModelSerializer):
    class Meta:
        model = Perfil
        fields = ['tipo']

class PesoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Peso
        fields = '__all__'

class RefeicaoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Refeicao
        fields = '__all__'

class ExercicioSerializer(serializers.ModelSerializer):
    # mostra o nome de usuário do cliente
    usuario_username = serializers.CharField(
        source='usuario.username', read_only=True
    )
    # mostra o nome de usuário do treinador (se houver)
    treinador_username = serializers.CharField(
        source='treinador.username', read_only=True
    )

    class Meta:
        model = Exercicio
        fields = [
            'id',
            'usuario',             # FK para usuário que fez
            'usuario_username',    # username do usuário que fez
            'treinador',           # FK para educador_fisico que criou
            'treinador_username',  # username do treinador
            'data',
            'tipo',
            'duracao_minutos',
        ]


class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    tipo = serializers.ChoiceField(choices=Perfil.TIPOS, write_only=True)

    class Meta:
        model = User
        fields = ['username', 'password', 'tipo']

    def create(self, validated_data):
        tipo = validated_data.pop('tipo')
        user = User(username=validated_data['username'])
        user.set_password(validated_data['password'])
        user.save()
        Perfil.objects.create(usuario=user, tipo=tipo)
        return user

class AnamneseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Anamnese
        fields = ['usuario', 'idade', 'altura_cm', 'peso_inicial', 'alergias', 'objetivo']
        read_only_fields = ['usuario']

class AlimentoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Alimento
        fields = '__all__'

class CardapioSerializer(serializers.ModelSerializer):
    # para gravar/ler apenas as PKs dos alimentos
    alimentos = serializers.PrimaryKeyRelatedField(
        many=True,
        queryset=Alimento.objects.all()
    )
    # restringe a escolha de paciente a usuários do tipo "paciente"
    paciente = serializers.PrimaryKeyRelatedField(
        queryset=User.objects.filter(perfil__tipo='paciente')
    )

    class Meta:
        model = Cardapio
        fields = ['id', 'paciente', 'alimentos', 'data_inicio', 'data_fim']

from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

class MyTokenObtainPairSerializer(TokenObtainPairSerializer):
    def validate(self, attrs):
        data = super().validate(attrs)
        # adiciona o tipo de usuário na resposta
        data['tipo'] = self.user.perfil.tipo
        return data
