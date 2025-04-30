from rest_framework import serializers
from django.contrib.auth.models import User

from rest_framework.exceptions import NotFound
from rest_framework.exceptions import PermissionDenied

from .models import (
    Perfil, 
    Peso,
    Refeicao, 
    Exercicio, 
    Anamnese, 
    Cardapio, 
    VinculoProfissionalPaciente,
    Ficha,
)

class PerfilSerializer(serializers.ModelSerializer):
    class Meta:
        model = Perfil
        fields = ['tipo']

class PesoSerializer(serializers.ModelSerializer):
    usuario_username = serializers.CharField(source='usuario.username', read_only=True)

    class Meta:
        model = Peso
        fields = ['usuario_username', 'data', 'peso']

class RefeicaoSerializer(serializers.ModelSerializer):
    # mostra o nome de usuário do cliente
    usuario_username = serializers.CharField(source='usuario.username', read_only=True)
    
    nutricionista_username = serializers.CharField(write_only=True)

    class Meta:
        model = Refeicao
        fields = [
            'usuario_username',    # username do usuário que fez
            'nutricionista_username',  # username do nutricionista
            'data',
            'descricao',
        ]
    
    def create(self, validated_data):
        user = self.context['request'].user

        nutricionista_username = validated_data.pop('nutricionista_username')
        try:
            nutricionista = User.objects.get(username=nutricionista_username)
        except User.DoesNotExist:
            raise NotFound('Nutricionista não encontrado.')
        
        if not VinculoProfissionalPaciente.objects.filter(paciente=user, profissional=nutricionista, profissional__perfil__tipo='nutricionista').exists():
            raise PermissionDenied(f'Paciente {user.username} não está associado ao nutricionista {nutricionista.username}.')

        validated_data.pop('usuario', None)
        validated_data.pop('nutricionista', None)

        return Refeicao.objects.create(
            usuario=user,
            nutricionista=nutricionista,
            **validated_data
        )

class ExercicioSerializer(serializers.ModelSerializer):
    # mostra o nome de usuário do cliente
    usuario_username = serializers.CharField(
        source='usuario.username', read_only=True
    )
    # mostra o nome de usuário do treinador (se houver)
    treinador_username = serializers.CharField(write_only=True)

    class Meta:
        model = Exercicio
        fields = [
            'usuario_username',    # username do usuário que fez
            'treinador_username',  # username do treinador
            'data',
            'descricao',
        ]
    
    def create(self, validated_data):
        user = self.context['request'].user

        treinador_username = validated_data.pop('treinador_username')
        try:
            treinador = User.objects.get(username=treinador_username)
        except User.DoesNotExist:
            raise NotFound('Treinador não encontrado.')
        
        if not VinculoProfissionalPaciente.objects.filter(paciente=user, profissional=treinador, profissional__perfil__tipo='educador_fisico').exists():
            raise PermissionDenied(f'Paciente {user.username} não está associado ao treinador {treinador.username}.')

        validated_data.pop('usuario', None)
        return Exercicio.objects.create(
            usuario=user,
            **validated_data
        )

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
    usuario_username = serializers.CharField(source='usuario.username', read_only=True)

    class Meta:
        model = Anamnese
        fields = ['usuario_username', 'idade', 'altura_cm', 'peso_inicial', 'alergias', 'objetivo']

class CardapioSerializer(serializers.ModelSerializer):
    # restringe a escolha de paciente a usuários do tipo "paciente"
    paciente_username = serializers.CharField(write_only=True)

    class Meta:
        model = Cardapio
        fields = ['paciente_username', 'data_inicio', 'data_fim', 'descricao']
    
    def create(self, validated_data):
        user = self.context['request'].user

        paciente_username = validated_data.pop('paciente_username')
        try:
            paciente = User.objects.get(username=paciente_username)
        except User.DoesNotExist:
            raise NotFound('Paciente não encontrado.')
        
        if not VinculoProfissionalPaciente.objects.filter(
                paciente=paciente,
                profissional=user
            ).exists():
            raise PermissionDenied(f'Paciente {paciente.username} não está associado ao nutricionista {user.username}.')

        validated_data.pop('paciente')
        return Cardapio.objects.create(
            paciente=paciente,
            **validated_data
        )

from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

class MyTokenObtainPairSerializer(TokenObtainPairSerializer):
    def validate(self, attrs):
        data = super().validate(attrs)
        # adiciona o tipo de usuário na resposta
        data['tipo'] = self.user.perfil.tipo
        return data

class VinculoSerializer(serializers.ModelSerializer):
    profissional_username = serializers.CharField(
        source='profissional.username', read_only=True
    )
    paciente_username = serializers.CharField(
        source='paciente.username', read_only=True
    )

    paciente_username_input = serializers.CharField(write_only=True, required=False)

    class Meta:
        model = VinculoProfissionalPaciente
        fields = [
            'profissional_username',
            'paciente_username',
            'paciente_username_input',
            'criado_em',
        ]
    
    def create(self, validated_data):
        paciente_username = validated_data.pop('paciente_username_input')

        try:
            paciente = User.objects.get(username=paciente_username)
        except User.DoesNotExist:
            raise NotFound('Paciente não encontrado.')
        
        profissional = self.context['request'].user

        if paciente.perfil.tipo != 'paciente':
            raise PermissionDenied('Usuário não é um paciente.')
        
        if VinculoProfissionalPaciente.objects.filter(paciente=paciente, profissional=profissional).exists():
            raise PermissionDenied('Vínculo já existe.')
        
        return VinculoProfissionalPaciente.objects.create(
            profissional=profissional,
            paciente=paciente
        )

class FichaSerializer(serializers.ModelSerializer):
    # restringe a escolha de paciente a usuários do tipo "paciente"
    usuario_username = serializers.CharField(write_only=True)

    class Meta:
        model = Ficha
        fields = ['usuario_username', 'data_inicio', 'data_fim', 'descricao']
    
    def create(self, validated_data):
        user = self.context['request'].user

        usuario_username = validated_data.pop('usuario_username')
        try:
            usuario = User.objects.get(username=usuario_username)
        except User.DoesNotExist:
            raise NotFound('Usuário não encontrado.')
        
        if not VinculoProfissionalPaciente.objects.filter(
                paciente=usuario,
                profissional=user
            ).exists():
            raise PermissionDenied(f'Usuário {usuario.username} não está associado ao treinador {user.username}.')

        validated_data.pop('usuario')
        return Ficha.objects.create(
            usuario=usuario,
            **validated_data
        )