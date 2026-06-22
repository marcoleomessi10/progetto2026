<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="it.model.CartItem" %>
<%@ page import="it.model.Product" %>
<%@ page import="it.model.User" %>

<%
    List<Product> products =
        (List<Product>) request.getAttribute("products");
    List<CartItem> cart =
        (List<CartItem>) session.getAttribute("cart");
    User user =
        (User) session.getAttribute("user");
    int cartCount = 0;

    if(cart != null) {
        for(CartItem item : cart) {
            cartCount += item.getQuantity();
        }
    }
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DAMA Shoes</title>
    <link rel="stylesheet" href="styles/style.css">
    <script src="scripts/validation.js" defer></script>
</head>

<body class="storefront">

<div class="top-strip">
    <span>Spedizione gratuita sopra &euro; 100</span>
    <div>
        <% if(user == null) { %>
            <a href="LoginServlet">Accedi</a>
            <a href="RegisterServlet">Registrati</a>
        <% } else { %>
            <span>Ciao, <%= user.getNome() %></span>
            <a href="LogoutServlet">Logout</a>
        <% } %>
    </div>
</div>

<header class="site-header">
    <a class="brand" href="HomeServlet">DAMA</a>
    <button class="nav-toggle" type="button" data-menu-toggle aria-expanded="false">Menu</button>

    <nav class="site-nav" data-menu>
        <a href="#catalogo">Novita</a>
        <a href="#catalogo">Sneakers</a>
        <a href="#catalogo">Running</a>
        <a href="#catalogo">Eleganti</a>
        <% if(user != null) { %>
            <a href="OrdersServlet">I miei ordini</a>
        <% } %>
        <% if(user != null && "ADMIN".equals(user.getRuolo())) { %>
            <a href="AdminProductServlet">Admin prodotti</a>
            <a href="AdminOrdersServlet">Admin ordini</a>
        <% } %>
    </nav>

    <div class="header-actions">
        <a class="icon-link" href="CartServlet">Carrello <span class="cart-count"><%= cartCount %></span></a>
    </div>
</header>

<main class="store-main">
    <section class="store-hero" data-hero>
        <div class="hero-media"></div>
        <div class="hero-sheen"></div>
        <div class="hero-copy">
            <p class="eyebrow">Nuova collezione</p>
            <h1>Move different.</h1>
            <p>Scarpe progettate per la strada, lo sport e ogni passo quotidiano.</p>
            <a class="button hero-button" href="#catalogo">Scopri la collezione</a>
        </div>
        <div class="hero-index">DAMA / 2026</div>
    </section>

    <section class="category-rail" aria-label="Categorie">
        <a href="#catalogo"><strong>01</strong><span>Sneakers</span></a>
        <a href="#catalogo"><strong>02</strong><span>Running</span></a>
        <a href="#catalogo"><strong>03</strong><span>Eleganti</span></a>
        <a href="CartServlet"><strong>04</strong><span>Il tuo carrello</span></a>
    </section>

    <section id="catalogo" class="catalog-section">
        <div class="catalog-title">
            <div>
                <p class="eyebrow">Scelti per te</p>
                <h2>Ultimi arrivi</h2>
            </div>
            <p>Design pulito, comfort quotidiano e performance.</p>
        </div>

        <div class="products">

        <% if(products == null || products.isEmpty()) { %>
            <p>Nessun prodotto disponibile.</p>
        <% } else { %>
            <% for(Product p : products) { %>

                <article class="product-card">
                    <a class="product-image-link" href="ProductServlet?id=<%= p.getId() %>">
                        <img src="images/<%= p.getImmagine() %>?v=2" alt="<%= p.getNome() %>" loading="lazy">
                        <span class="product-arrow">Apri</span>
                    </a>

                    <div class="card-body">
                        <div class="product-meta">
                            <span class="badge"><%= p.getCategoria() == null ? "DAMA" : p.getCategoria() %></span>
                            <span class="muted"><%= p.getQuantitaDisponibile() %> disponibili</span>
                        </div>

                        <h3><a href="ProductServlet?id=<%= p.getId() %>"><%= p.getNome() %></a></h3>
                        <p class="muted"><%= p.getMarca() %></p>
                        <p class="price">&euro; <%= String.format("%.2f", p.getPrezzo()) %></p>

                        <form action="CartServlet" method="post" class="cart-add-form">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="id" value="<%= p.getId() %>">
                            <button class="action-button action-primary product-add-button" type="submit" <%= p.getQuantitaDisponibile() <= 0 ? "disabled" : "" %>>
                                <span><%= p.getQuantitaDisponibile() <= 0 ? "Esaurito" : "Aggiungi al carrello" %></span>
                                <span class="action-button-icon" aria-hidden="true">&plus;</span>
                            </button>
                        </form>
                    </div>
                </article>

            <% } %>
        <% } %>

        </div>
    </section>

    <section class="motion-banner">
        <div class="motion-track">
            <span>RUN</span><span>MOVE</span><span>CREATE</span><span>REPEAT</span>
            <span>RUN</span><span>MOVE</span><span>CREATE</span><span>REPEAT</span>
        </div>
    </section>
</main>

<%@ include file="common/footer.jsp" %>

</body>
</html>
