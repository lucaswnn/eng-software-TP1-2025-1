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
    usuario = models.ForeignKey(User, on_delete=models.CASCADE)
    data = models.DateField()
    tipo = models.CharField(max_length=100)
    duracao_minutos = models.IntegerField()

    def __str__(self):
        return f"{self.usuario.username} – {self.data} – {self.tipo} ({self.duracao_minutos} min)"


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
        help_text="Paciente que receberá este cardápio"
    )
    alimentos = models.ManyToManyField(
        Alimento,
        help_text="Itens que compõem o cardápio"
    )
    data_inicio = models.DateField()
    data_fim = models.DateField()

    def __str__(self):
        return f"Cardápio de {self.paciente.username} de {self.data_inicio} a {self.data_fim}"
