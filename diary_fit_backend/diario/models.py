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
    usuario = models.ForeignKey(User, on_delete=models.CASCADE)
    data = models.DateField()
    descricao = models.TextField()

    def __str__(self):
        return f"{self.usuario.username} – {self.data} – Refeição"

class Exercicio(models.Model):
    usuario = models.ForeignKey(
        User, on_delete=models.CASCADE,
        related_name='exercicios_feitos'
    )
    treinador = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        null=True, blank=True,
        limit_choices_to={'perfil__tipo': 'educador_fisico'},
        related_name='exercicios_criados'
    )
    data = models.DateField()
    tipo = models.CharField(max_length=100)
    duracao_minutos = models.IntegerField()

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
class Alimento(models.Model):
    nome = models.CharField(max_length=100)
    calorias = models.IntegerField(help_text="kcal por porção")
    proteina_g = models.DecimalField(max_digits=6, decimal_places=2)
    carboidrato_g = models.DecimalField(max_digits=6, decimal_places=2)
    gordura_g = models.DecimalField(max_digits=6, decimal_places=2)

    def __str__(self):
        return f"{self.nome} ({self.calorias} kcal)"

class Cardapio(models.Model):
    paciente = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        limit_choices_to={'perfil__tipo': 'paciente'},
        related_name='cardapios_paciente'
    )
    nutricionista = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        limit_choices_to={'perfil__tipo': 'nutricionista'},
        related_name='cardapios_nutricionista'
    )
    descricao = models.TextField(
        default='Sem descrição',
        help_text="Descrição do cardápio"
    )
    data_inicio = models.DateField()
    data_fim    = models.DateField()

    def __str__(self):
        return f"Cardápio {self.id} de {self.paciente.username}"