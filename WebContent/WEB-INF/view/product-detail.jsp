<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="it.model.Product" %>

<%
    Product product =
        (Product) request.getAttribute("product");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= product.getNome() %> - Shoe Store</title>
    <link rel="stylesheet" href="styles/style.css">
    <script src="scripts/validation.js" defer></script>
</head>
<body class="product-detail-page">

<nav>
    <a href="HomeServlet">Home</a>
    <a href="CartServlet">Carrello</a>
</nav>

<h1><%= product.getNome() %></h1>

<div class="product-card">
    <img src="images/<%= product.getImmagine() %>?v=15" alt="<%= product.getNome() %>" width="220">
    <p>Marca: <%= product.getMarca() %></p>
    <p>Categoria: <%= product.getCategoria() %></p>
    <p><%= product.getDescrizione() %></p>
    <p>Disponibili: <%= product.getQuantitaDisponibile() %></p>
    <p>Prezzo: &euro; <%= product.getPrezzo() %></p>

    <form action="CartServlet" method="post">
        <input type="hidden" name="action" value="add">
        <input type="hidden" name="id" value="<%= product.getId() %>">
        <button class="action-button action-primary" type="submit">
            <span>Aggiungi al carrello</span>
            <span class="action-button-icon" aria-hidden="true">&plus;</span>
        </button>
    </form>
</div>

<%@ include file="common/footer.jsp" %>

</body>
</html>
