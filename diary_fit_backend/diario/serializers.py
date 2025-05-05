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
    usuario_username = serializers.CharField(source='usuario.username', read_only=True)

    class Meta:
        model = Refeicao
        fields = [
            'usuario_username',
            'data',
            'descricao',
        ]
    
    def create(self, validated_data):
        user = self.context['request'].user

        # busca vínculo
        try:
            if user.perfil.tipo == 'nutricionista':
                vinculo = VinculoProfissionalPaciente.objects.get(
                    paciente=user,
                    profissional__perfil__tipo='nutricionista'
                )
        except VinculoProfissionalPaciente.DoesNotExist:
            raise PermissionDenied(f'Paciente {user.username} não está associado a nenhum nutricionista.')

        validated_data.pop('nutricionista', None)
        validated_data.pop('usuario', None)
        return Refeicao.objects.create(
            usuario=user,
            **validated_data
        )

class ExercicioSerializer(serializers.ModelSerializer):
    usuario_username = serializers.CharField(source='usuario.username', read_only=True)

    class Meta:
        model = Exercicio
        fields = [
            'usuario_username',
            'data',
            'descricao',
        ]
    
    def create(self, validated_data):
        user = self.context['request'].user

        # busca vínculo
        try:
            if user.perfil.tipo == 'educador_fisico':
                vinculo = VinculoProfissionalPaciente.objects.get(
                    paciente=user,
                    profissional__perfil__tipo='educador_fisico'
                )
        except VinculoProfissionalPaciente.DoesNotExist:
            raise PermissionDenied(f'Paciente {user.username} não está associado a nenhu educador físico.')

        validated_data.pop('educador_fisico', None)
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
    paciente_username = serializers.SerializerMethodField()
    paciente_username_input = serializers.CharField(write_only=True)

    class Meta:
        model = Cardapio
        fields = ['paciente_username', 'paciente_username_input', 'data_inicio', 'data_fim', 'descricao']
    
    def get_paciente_username(self, obj):
        return obj.paciente.username

    def create(self, validated_data):
        user = self.context['request'].user

        paciente_username = validated_data.pop('paciente_username_input')
        try:
            paciente = User.objects.get(username=paciente_username)
        except User.DoesNotExist:
            raise NotFound('Paciente não encontrado.')
        
        if not VinculoProfissionalPaciente.objects.filter(
                paciente=paciente,
                profissional=user
            ).exists():
            raise PermissionDenied(f'Paciente {paciente.username} não está associado ao nutricionista {user.username}.')

        validated_data.pop('paciente',None)
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

    tipo_profissional = serializers.CharField(
        source='profissional.perfil.tipo', read_only=True
    )

    class Meta:
        model = VinculoProfissionalPaciente
        fields = [
            'profissional_username',
            'paciente_username',
            'paciente_username_input',
            'tipo_profissional',
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
    usuario_username = serializers.SerializerMethodField()
    usuario_username_write = serializers.CharField(write_only=True)

    class Meta:
        model = Ficha
        fields = ['usuario_username', 'usuario_username_write', 'data_inicio', 'data_fim', 'descricao']
    
    def get_usuario_username(self, obj):
        return obj.usuario.username

    def create(self, validated_data):
        user = self.context['request'].user

        usuario_username = validated_data.pop('usuario_username_write')
        try:
            usuario = User.objects.get(username=usuario_username)
        except User.DoesNotExist:
            raise NotFound('Usuário não encontrado.')
        
        if not VinculoProfissionalPaciente.objects.filter(
                paciente=usuario,
                profissional=user
            ).exists():
            raise PermissionDenied(f'Usuário {usuario.username} não está associado ao treinador {user.username}.')

        validated_data.pop('usuario', None)
        return Ficha.objects.create(
            usuario=usuario,
            **validated_data
        )