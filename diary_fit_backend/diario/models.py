from django.db import models
from django.contrib.auth.models import User

class Perfil(models.Model):
    TIPOS = [
        ('paciente', 'Paciente'),
        ('nutricionista', 'Nutricionista'),
        ('educador_fisico', 'Educador Físico'),
    ]
    usuario = models.OneToOneField(User, on_delete=models.CASCADE)
    tipo = models.CharField(max_length=20, choices=TIPOS)

    def __str__(self):
        return f"{self.usuario.username} – {self.get_tipo_display()}"

class Peso(models.Model):
    usuario = models.ForeignKey(User, on_delete=models.CASCADE)
    data = models.DateField()
    peso = models.DecimalField(max_digits=5, decimal_places=2)

    def __str__(self):
        return f"{self.usuario.username} – {self.data} – {self.peso} kg"

class Refeicao(models.Model):
    usuario = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='refeicoes_feitas'
    )
    
    data = models.DateField()
    descricao = models.TextField()

    def __str__(self):
        return f"{self.usuario.username} – {self.data} – Refeição"

class Exercicio(models.Model):
    usuario = models.ForeignKey(
        User, on_delete=models.CASCADE,
        related_name='exercicios_feitos'
    )
    
    data = models.DateField()
    descricao = models.CharField(max_length=100)

    def __str__(self):
        return f"{self.tipo} por {self.usuario.username}"

class Anamnese(models.Model):
    usuario = models.OneToOneField(
        User, on_delete=models.CASCADE,
        help_text="Paciente ao qual esta ficha pertence"
    )
    idade = models.IntegerField()
    altura_cm = models.DecimalField(max_digits=5, decimal_places=2)
    peso_inicial = models.DecimalField(max_digits=5, decimal_places=2)
    alergias = models.TextField(blank=True)
    objetivo = models.CharField(max_length=200)

    def __str__(self):
        return f"Anamnese de {self.usuario.username}"

class Cardapio(models.Model):
    paciente = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        limit_choices_to={'perfil__tipo': 'paciente'},
        related_name='cardapios_paciente'
    )
    
    descricao = models.TextField(
        default='Sem descrição',
        help_text="Descrição do cardápio"
    )
    data_inicio = models.DateField()
    data_fim    = models.DateField()

    def __str__(self):
        return f"Cardápio {self.id} de {self.paciente.username}"

class VinculoProfissionalPaciente(models.Model):
    PROFISSIONAL_TIPOS = [
        ('nutricionista', 'Nutricionista'),
        ('educador_fisico', 'Educador Físico'),
    ]

    profissional = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        limit_choices_to={'perfil__tipo__in': ['nutricionista', 'educador_fisico']},
        related_name='vinculos_profissional'
    )
    paciente = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        limit_choices_to={'perfil__tipo': 'paciente'},
        related_name='vinculos_paciente'
    )
    criado_em = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('profissional', 'paciente')
        verbose_name = 'Vínculo Profissional–Paciente'
        verbose_name_plural = 'Vínculos Profissional–Paciente'

    def __str__(self):
        return f"{self.profissional.username} ↔ {self.paciente.username}"

class Ficha(models.Model):
    usuario = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        limit_choices_to={'perfil__tipo': 'paciente'},
        related_name='fichas_paciente'
    )
    
    descricao = models.TextField()
    data_inicio = models.DateField()
    data_fim = models.DateField()

    def __str__(self):
        return f"Ficha de {self.usuario.username} – {self.data}"