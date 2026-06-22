<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="it.model.Product" %>

<%
    List<Product> products =
        (List<Product>) request.getAttribute("products");
    Product editProduct =
        (Product) request.getAttribute("editProduct");
    String token =
        (String) session.getAttribute("authToken");
    boolean editing =
        editProduct != null;
    String msgSuccess = (String) request.getAttribute("success");
    String msgError   = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Prodotti — Shoe Store</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/styles/style.css">
    <script src="<%=request.getContextPath()%>/scripts/validation.js" defer></script>
    <style>
        .admin-layout {
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 2rem;
            align-items: start;
        }
        .admin-sidebar { position: sticky; top: 80px; }
        .status-dot {
            display: inline-block;
            width: 8px; height: 8px;
            border-radius: 50%;
            margin-right: .35rem;
            vertical-align: middle;
        }
        .dot-active   { background: #12b76a; }
        .dot-inactive { background: #d0d5dd; }
        .badge-status {
            display: inline-flex;
            align-items: center;
            padding: .2rem .6rem;
            border-radius: 999px;
            font-size: .78rem;
            font-weight: 700;
        }
        .badge-active   { background: #ecfdf3; color: #027a48; }
        .badge-inactive { background: #f2f4f7; color: #667085; }
        @media (max-width: 900px) {
            .admin-layout { grid-template-columns: 1fr; }
            .admin-sidebar { position: static; }
        }
    </style>
</head>
<body>

<nav>
    <a href="<%=request.getContextPath()%>/HomeServlet">&#8592; Home</a>
    <span>|</span>
    <a href="<%=request.getContextPath()%>/AdminProductServlet">Prodotti</a>
    <a href="<%=request.getContextPath()%>/AdminOrdersServlet">Ordini</a>
    <a href="<%=request.getContextPath()%>/LogoutServlet">Logout</a>
</nav>

<div class="container">

    <div class="page-heading">
        <div>
            <p class="eyebrow">Pannello Admin</p>
            <h1 style="margin:0;font-size:2rem;">Gestione Prodotti</h1>
        </div>
        <span class="badge"><%= products != null ? products.size() : 0 %> prodotti</span>
    </div>

    <% if (msgSuccess != null) { %>
        <div class="message success"><%= msgSuccess %></div>
    <% } %>
    <% if (msgError != null) { %>
        <div class="message error"><%= msgError %></div>
    <% } %>

    <div class="admin-layout">

        <!-- FORM -->
        <div class="admin-sidebar">
            <div class="card form-panel" style="max-width:100%;padding:1.5rem;">
                <h2 style="margin-top:0;font-size:1.2rem;">
                    <%= editing ? "&#9998; Modifica prodotto" : "&#43; Nuovo prodotto" %>
                </h2>

                <form action="<%=request.getContextPath()%>/AdminProductServlet" method="post" data-validate="product">
                    <input type="hidden" name="token" value="<%= token %>">
                    <input type="hidden" name="action" value="<%= editing ? "update" : "save" %>">
                    <% if (editing) { %>
                        <input type="hidden" name="id" value="<%= editProduct.getId() %>">
                    <% } %>

                    <div style="display:grid;gap:.9rem;">
                        <label>Nome
                            <input type="text" name="nome" data-rule="name"
                                   value="<%= editing ? editProduct.getNome() : "" %>" required>
                            <span class="field-error" data-error-for="nome"></span>
                        </label>

                        <label>Marca
                            <input type="text" name="marca" data-rule="name"
                                   value="<%= editing ? editProduct.getMarca() : "" %>" required>
                            <span class="field-error" data-error-for="marca"></span>
                        </label>

                        <label>Descrizione
                            <textarea name="descrizione"><%= editing ? editProduct.getDescrizione() : "" %></textarea>
                        </label>

                        <div class="form-grid">
                            <label>Prezzo (€)
                                <input type="number" step="0.01" min="0.01" name="prezzo" data-rule="price"
                                       value="<%= editing ? String.valueOf(editProduct.getPrezzo()) : "" %>" required>
                                <span class="field-error" data-error-for="prezzo"></span>
                            </label>

                            <label>Quantità
                                <input type="number" min="0" name="quantita" data-rule="quantity"
                                       value="<%= editing ? String.valueOf(editProduct.getQuantitaDisponibile()) : "0" %>" required>
                                <span class="field-error" data-error-for="quantita"></span>
                            </label>
                        </div>

                        <label>Categoria
                            <select name="categoria" data-rule="required" required>
                                <option value="">Scegli categoria</option>
                                <option value="Sneakers"  <%= editing && "Sneakers".equals(editProduct.getCategoria())  ? "selected" : "" %>>Sneakers</option>
                                <option value="Running"   <%= editing && "Running".equals(editProduct.getCategoria())   ? "selected" : "" %>>Running</option>
                                <option value="Eleganti"  <%= editing && "Eleganti".equals(editProduct.getCategoria())  ? "selected" : "" %>>Eleganti</option>
                            </select>
                            <span class="field-error" data-error-for="categoria"></span>
                        </label>

                        <label>Immagine (nome file)
                            <input type="text" name="immagine"
                                   value="<%= editing ? editProduct.getImmagine() : "shoe.jpg" %>">
                        </label>

                        <label class="checkbox-label">
                            <input type="checkbox" name="attivo"
                                   <%= !editing || editProduct.isAttivo() ? "checked" : "" %>>
                            Prodotto attivo
                        </label>

                        <button class="action-button action-primary" type="submit">
                            <span><%= editing ? "Salva modifiche" : "Aggiungi prodotto" %></span>
                            <span class="action-button-icon" aria-hidden="true"><%= editing ? "&#10003;" : "&#43;" %></span>
                        </button>

                        <% if (editing) { %>
                            <a href="<%=request.getContextPath()%>/AdminProductServlet"
                               style="text-align:center;color:#667085;font-weight:700;text-decoration:underline;">
                                Annulla modifica
                            </a>
                        <% } %>
                    </div>
                </form>
            </div>
        </div>

        <!-- TABELLA -->
        <div>
            <div class="table-wrap card" style="padding:0;border-radius:1rem;overflow:hidden;">
                <table>
                    <thead>
                        <tr>
                            <th style="width:40px;">#</th>
                            <th>Nome</th>
                            <th>Marca</th>
                            <th>Prezzo</th>
                            <th>Categoria</th>
                            <th>Stock</th>
                            <th>Stato</th>
                            <th style="width:140px;"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (products != null) { for (Product p : products) { %>
                        <tr>
                            <td class="muted"><%= p.getId() %></td>
                            <td><strong><%= p.getNome() %></strong></td>
                            <td><%= p.getMarca() %></td>
                            <td>&euro;&nbsp;<%= p.getPrezzo() %></td>
                            <td><span class="badge"><%= p.getCategoria() %></span></td>
                            <td>
                                <% if (p.getQuantitaDisponibile() == 0) { %>
                                    <span style="color:#b42318;font-weight:700;">Esaurito</span>
                                <% } else if (p.getQuantitaDisponibile() < 5) { %>
                                    <span style="color:#dc6803;font-weight:700;"><%= p.getQuantitaDisponibile() %> &darr;</span>
                                <% } else { %>
                                    <%= p.getQuantitaDisponibile() %>
                                <% } %>
                            </td>
                            <td>
                                <span class="badge-status <%= p.isAttivo() ? "badge-active" : "badge-inactive" %>">
                                    <span class="status-dot <%= p.isAttivo() ? "dot-active" : "dot-inactive" %>"></span>
                                    <%= p.isAttivo() ? "Attivo" : "Inattivo" %>
                                </span>
                            </td>
                            <td>
                                <div class="actions">
                                    <a class="action-button action-secondary action-compact"
                                       href="<%=request.getContextPath()%>/AdminProductServlet?edit=<%= p.getId() %>">
                                       Modifica
                                    </a>
                                    <form action="<%=request.getContextPath()%>/AdminProductServlet" method="post" style="margin:0;">
                                        <input type="hidden" name="token" value="<%= token %>">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= p.getId() %>">
                                        <button class="action-button action-danger action-compact" type="submit"
                                                onclick="return confirm('Eliminare il prodotto?')">
                                            Elimina
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div><!-- /admin-layout -->
</div><!-- /container -->

<%@ include file="../common/footer.jsp" %>

</body>
</html>
