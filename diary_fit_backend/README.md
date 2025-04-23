**# DiaryFit Backend API**

Este documento serve como guia de integração para o frontend consumir os endpoints do backend DiaryFit.

---

## Base URL (Ambiente de desenvolvimento)

- **Localhost (API server)**: `http://127.0.0.1:8000/`
- No emulador Android use: `http://10.0.2.2:8000/`
- Em iOS Simulator: `http://127.0.0.1:8000/`

---

## Fluxo de Autenticação (JWT)

1. **Cadastro de Usuário**  
   `POST /api/signup/`  
   **Body** (JSON):
   ```json
   {
     "username": "nome_do_usuario",
     "password": "senha_secreta",
     "tipo":     "paciente"    // ou "nutricionista", "educador_fisico"
   }
   ```

2. **Login (Obter Tokens)**  
   `POST /api/token/`  
   **Body** (JSON):
   ```json
   {
     "username": "nome_do_usuario",
     "password": "senha_secreta"
   }
   ```
   **Resposta**:
   ```json
   {
     "refresh": "<refresh_token>",
     "access":  "<access_token>"
   }
   ```

3. **Renovar Token**  
   `POST /api/token/refresh/`  
   **Body** (JSON):
   ```json
   { "refresh": "<refresh_token>" }
   ```

4. **Usar o Bearer Token**  
   Para chamadas protegidas, inclua no header:
   ```http
   Authorization: Bearer <access_token>
   ```

---

## Endpoints Principais

| Método | Rota                  | Descrição                                            |
|--------|-----------------------|------------------------------------------------------|
| POST   | `/api/signup/`        | Cadastra novo usuário + perfil                       |
| POST   | `/api/token/`         | Login → retorna `access` e `refresh` tokens          |
| POST   | `/api/token/refresh/` | Renova o token de acesso                             |
| GET    | `/api/pesos/`         | Lista registros de peso do usuário logado            |
| POST   | `/api/pesos/`         | Cria novo registro de peso                           |
| GET    | `/api/refeicoes/`     | Lista registros de refeição                          |
| POST   | `/api/refeicoes/`     | Cria novo registro de refeição                       |
| GET    | `/api/exercicios/`    | Lista registros de exercício                         |
| POST   | `/api/exercicios/`    | Cria novo registro de exercício                      |
| GET    | `/api/anamnese/`      | Lê/Lista ficha de anamnese do usuário                |
| POST   | `/api/anamnese/`      | Cria/Atualiza ficha de anamnese                      |
| GET    | `/api/calendario/`    | Retorna dados agrupados por data (refeição/exercício)|
| GET    | `/api/alimentos/`     | Lista catálogo de alimentos                          |
| POST   | `/api/alimentos/`     | Cria novo alimento                                   |
| GET    | `/api/cardapios/`     | Lista cardápios (paciente vê só os seus; nutricionista vê todos)|
| POST   | `/api/cardapios/`     | Cria novo cardápio (lista de IDs de alimentos)       |

---

## Documentação Interativa

- **Swagger UI**:  `http://127.0.0.1:8000/swagger/`
- **Redoc**:       `http://127.0.0.1:8000/redoc/`

Nelas, você pode explorar cada endpoint e usar o botão **Authorize** para colar o Bearer Token e testar diretamente.

---

## Observações

- **Content-Type**: Todas as requisições POST/PUT devem usar `Content-Type: application/json`.
- **Cuidado com datas**: Formato ISO `YYYY-MM-DD` para campos `data`, `data_inicio` e `data_fim`.
- **Emulador Android**: use `10.0.2.2` no lugar de `127.0.0.1`.

---

Qualquer dúvida, estarei disponível para apoiar na integração!

