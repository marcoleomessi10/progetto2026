package it.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import it.model.Order;
import it.model.OrderItem;

public class OrderDaoImpl implements OrderDao {

    private DataSource ds;

    public OrderDaoImpl(DataSource ds) 
    {
        this.ds = ds;
    }

    @Override
    public int doSaveOrder(Order o) 
    {
        String sql = "INSERT INTO orders "
                + "(user_id, data_ordine, totale, indirizzo_spedizione, metodo_pagamento, stato) "
                + "VALUES (?, NOW(), ?, ?, ?, ?)";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, o.getUserId());
            ps.setDouble(2, o.getTotale());
            ps.setString(3, o.getIndirizzoSpedizione());
            ps.setString(4, o.getMetodoPagamento());
            ps.setString(5, o.getStato());

            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }

    @Override
    public void doSaveOrderItem(OrderItem i) 
    {
        String sql = "INSERT INTO order_items "
                + "(order_id, product_id, nome_prodotto, marca_prodotto, taglia, prezzo_acquisto, quantita, subtotale) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, i.getOrderId());
            ps.setInt(2, i.getProductId());
            ps.setString(3, i.getNomeProdotto());
            ps.setString(4, i.getMarcaProdotto());
            ps.setInt(5, i.getTaglia());
            ps.setDouble(6, i.getPrezzoAcquisto());
            ps.setInt(7, i.getQuantita());
            ps.setDouble(8, i.getSubtotale());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Order> doRetrieveByUser(int userId) 
    {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY data_ordine DESC";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order o = new Order();

                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setDataOrdine(rs.getTimestamp("data_ordine"));
                o.setTotale(rs.getDouble("totale"));
                o.setIndirizzoSpedizione(rs.getString("indirizzo_spedizione"));
                o.setMetodoPagamento(rs.getString("metodo_pagamento"));
                o.setStato(rs.getString("stato"));

                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Order> doRetrieveAll() 
    {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY data_ordine DESC";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order o = new Order();

                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setDataOrdine(rs.getTimestamp("data_ordine"));
                o.setTotale(rs.getDouble("totale"));
                o.setIndirizzoSpedizione(rs.getString("indirizzo_spedizione"));
                o.setMetodoPagamento(rs.getString("metodo_pagamento"));
                o.setStato(rs.getString("stato"));

                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Order> doRetrieveByDateRange(String startDate, String endDate) 
    {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE data_ordine BETWEEN ? AND ?";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, startDate);
            ps.setString(2, endDate);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order o = new Order();

                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setDataOrdine(rs.getTimestamp("data_ordine"));
                o.setTotale(rs.getDouble("totale"));
                o.setStato(rs.getString("stato"));

                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
