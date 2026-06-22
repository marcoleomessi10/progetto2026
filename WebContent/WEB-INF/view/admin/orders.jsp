<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="it.model.Order" %>
<%@ page import="it.model.OrderItem" %>

<%
    List<Order> orders =
        (List<Order>) request.getAttribute("orders");
    Order selectedOrder =
        (Order) request.getAttribute("selectedOrder");
    List<OrderItem> items =
        (List<OrderItem>) request.getAttribute("items");
    String token =
        (String) session.getAttribute("authToken");
    String msgSuccess = (String) request.getAttribute("success");
    String msgError   = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Ordini — Shoe Store</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/styles/style.css">
    <style>
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: .3rem;
            padding: .25rem .7rem;
            border-radius: 999px;
            font-size: .78rem;
            font-weight: 700;
        }
        .status-elaborazione { background: #fffaeb; color: #b54708; }
        .status-spedito      { background: #eff8ff; color: #175cd3; }
        .status-consegnato   { background: #ecfdf3; color: #027a48; }

        .filter-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 1rem;
            padding: 1.25rem 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 8px rgba(15,23,42,.04);
        }
        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 1rem;
            align-items: end;
        }
        .detail-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 1rem;
            padding: 1.5rem;
            margin-top: 2rem;
            box-shadow: 0 2px 8px rgba(15,23,42,.04);
        }
        .detail-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
            margin-bottom: 1.25rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border);
        }
        .order-meta {
            display: flex;
            gap: 2rem;
            flex-wrap: wrap;
            margin-bottom: 1.25rem;
        }
        .order-meta-item { display: flex; flex-direction: column; gap: .2rem; }
        .order-meta-item small { color: var(--muted); font-size: .78rem; font-weight: 700; text-transform: uppercase; }
        .order-meta-item strong { font-size: 1rem; }
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
            <h1 style="margin:0;font-size:2rem;">Gestione Ordini</h1>
        </div>
        <span class="badge"><%= orders != null ? orders.size() : 0 %> ordini</span>
    </div>

    <% if (msgSuccess != null) { %>
        <div class="message success"><%= msgSuccess %></div>
    <% } %>
    <% if (msgError != null) { %>
        <div class="message error"><%= msgError %></div>
    <% } %>

    <!-- FILTRI -->
    <div class="filter-card">
        <form action="<%=request.getContextPath()%>/AdminOrdersServlet" method="get">
            <div class="filter-grid">
                <label>ID cliente
                    <input type="number" name="userId" min="1"
                           value="<%= request.getParameter("userId") != null ? request.getParameter("userId") : "" %>"
                           placeholder="es. 3">
                </label>
                <label>Stato
                    <select name="stato">
                        <option value="">Tutti</option>
                        <option value="PROCESSING" <%= "PROCESSING".equals(request.getParameter("stato")) ? "selected" : "" %>>In elaborazione</option>
                        <option value="SHIPPED"    <%= "SHIPPED".equals(request.getParameter("stato"))    ? "selected" : "" %>>Spedito</option>
                        <option value="DELIVERED"  <%= "DELIVERED".equals(request.getParameter("stato"))  ? "selected" : "" %>>Consegnato</option>
                    </select>
                </label>
                <label>Da
                    <input type="date" name="startDate"
                           value="<%= request.getParameter("startDate") != null ? request.getParameter("startDate") : "" %>">
                </label>
                <label>A
                    <input type="date" name="endDate"
                           value="<%= request.getParameter("endDate") != null ? request.getParameter("endDate") : "" %>">
                </label>
                <div class="admin-filter-actions">
                    <button class="action-button action-secondary action-compact" type="submit">Filtra</button>
                    <a class="action-link" href="<%=request.getContextPath()%>/AdminOrdersServlet">Azzera</a>
                </div>
            </div>
        </form>
    </div>

    <!-- TABELLA ORDINI -->
    <div class="table-wrap card" style="padding:0;border-radius:1rem;overflow:hidden;">
        <table>
            <thead>
                <tr>
                    <th style="width:50px;">#</th>
                    <th>Cliente</th>
                    <th>Data</th>
                    <th>Totale</th>
                    <th>Stato</th>
                    <th style="width:100px;"></th>
                </tr>
            </thead>
            <tbody>
                <% if (orders != null && !orders.isEmpty()) {
                       for (Order o : orders) {
                           String statoClass = "status-elaborazione";
                           String statoLabel = "In elaborazione";
                           if ("SHIPPED".equals(o.getStato()))   { statoClass = "status-spedito";    statoLabel = "Spedito"; }
                           if ("DELIVERED".equals(o.getStato())) { statoClass = "status-consegnato"; statoLabel = "Consegnato"; }
                %>
                <tr <%= selectedOrder != null && selectedOrder.getId() == o.getId() ? "style='background:#f0f5ff;'" : "" %>>
                    <td class="muted"><%= o.getId() %></td>
                    <td><strong>Cliente #<%= o.getUserId() %></strong></td>
                    <td class="muted"><%= o.getDataOrdine() %></td>
                    <td><strong>&euro;&nbsp;<%= o.getTotale() %></strong></td>
                    <td><span class="status-badge <%= statoClass %>"><%= statoLabel %></span></td>
                    <td>
                        <a class="action-button action-secondary action-compact"
                           href="<%=request.getContextPath()%>/AdminOrdersServlet?id=<%= o.getId() %>">
                           Dettaglio
                        </a>
                    </td>
                </tr>
                <% } } else { %>
                <tr><td colspan="6" style="text-align:center;color:var(--muted);padding:2rem;">Nessun ordine trovato.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- DETTAGLIO ORDINE -->
    <% if (selectedOrder != null && items != null) {
           String statoClass = "status-elaborazione";
           String statoLabel = "In elaborazione";
           if ("SHIPPED".equals(selectedOrder.getStato()))   { statoClass = "status-spedito";    statoLabel = "Spedito"; }
           if ("DELIVERED".equals(selectedOrder.getStato())) { statoClass = "status-consegnato"; statoLabel = "Consegnato"; }
    %>
    <div class="detail-card">
        <div class="detail-header">
            <div>
                <p class="eyebrow" style="margin:0 0 .25rem;">Dettaglio ordine</p>
                <h2 style="margin:0;font-size:1.5rem;">#<%= selectedOrder.getId() %></h2>
            </div>
            <span class="status-badge <%= statoClass %>"><%= statoLabel %></span>
        </div>

        <div class="order-meta">
            <div class="order-meta-item">
                <small>Cliente</small>
                <strong>#<%= selectedOrder.getUserId() %></strong>
            </div>
            <div class="order-meta-item">
                <small>Data</small>
                <strong><%= selectedOrder.getDataOrdine() %></strong>
            </div>
            <div class="order-meta-item">
                <small>Indirizzo</small>
                <strong><%= selectedOrder.getIndirizzoSpedizione() %></strong>
            </div>
            <div class="order-meta-item">
                <small>Pagamento</small>
                <strong><%= selectedOrder.getMetodoPagamento() %></strong>
            </div>
            <div class="order-meta-item">
                <small>Totale</small>
                <strong style="font-size:1.2rem;">&euro;&nbsp;<%= selectedOrder.getTotale() %></strong>
            </div>
        </div>

        <!-- Cambio stato -->
        <% if (token != null) { %>
        <form action="<%=request.getContextPath()%>/AdminOrdersServlet" method="post"
              style="display:flex;align-items:center;gap:1rem;flex-wrap:wrap;margin-bottom:1.5rem;">
            <input type="hidden" name="token" value="<%= token %>">
            <input type="hidden" name="action" value="updateStatus">
            <input type="hidden" name="id" value="<%= selectedOrder.getId() %>">
            <label style="display:flex;align-items:center;gap:.5rem;font-weight:700;">
                Cambia stato:
                <select name="stato" style="width:auto;">
                    <option value="PROCESSING" <%= "PROCESSING".equals(selectedOrder.getStato()) ? "selected" : "" %>>In elaborazione</option>
                    <option value="SHIPPED"    <%= "SHIPPED".equals(selectedOrder.getStato())    ? "selected" : "" %>>Spedito</option>
                    <option value="DELIVERED"  <%= "DELIVERED".equals(selectedOrder.getStato())  ? "selected" : "" %>>Consegnato</option>
                </select>
            </label>
            <button class="action-button action-primary action-compact" type="submit">
                Aggiorna stato
            </button>
        </form>
        <% } %>

        <!-- Articoli -->
        <div class="table-wrap" style="border:1px solid var(--border);border-radius:.75rem;overflow:hidden;">
            <table>
                <thead>
                    <tr>
                        <th>Prodotto</th>
                        <th>Marca</th>
                        <th>Taglia</th>
                        <th>Prezzo</th>
                        <th>Qtà</th>
                        <th>Subtotale</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (OrderItem item : items) { %>
                    <tr>
                        <td><strong><%= item.getNomeProdotto() %></strong></td>
                        <td><%= item.getMarcaProdotto() %></td>
                        <td><%= item.getTaglia() %></td>
                        <td>&euro;&nbsp;<%= item.getPrezzoAcquisto() %></td>
                        <td><%= item.getQuantita() %></td>
                        <td><strong>&euro;&nbsp;<%= item.getSubtotale() %></strong></td>
                    </tr>
                    <% } %>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="5" style="text-align:right;font-weight:700;color:var(--muted);">Totale ordine</td>
                        <td><strong style="font-size:1.1rem;">&euro;&nbsp;<%= selectedOrder.getTotale() %></strong></td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>
    <% } %>

</div><!-- /container -->

<%@ include file="../common/footer.jsp" %>

</body>
</html>
