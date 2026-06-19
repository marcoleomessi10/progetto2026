package it.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import it.model.Product;

public class ProductDaoImpl implements ProductDao {

    private DataSource ds;

    public ProductDaoImpl(DataSource ds) 
    {
        this.ds = ds;
    }

    @Override
    public List<Product> doRetrieveAll() 
    {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE attivo = TRUE";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();

                p.setId(rs.getInt("id"));
                p.setNome(rs.getString("nome"));
                p.setDescrizione(rs.getString("descrizione"));
                p.setMarca(rs.getString("marca"));
                p.setPrezzo(rs.getDouble("prezzo"));
                p.setQuantitaDisponibile(rs.getInt("quantita_disponibile"));
                p.setNumeroScarpaMin(rs.getInt("numero_scarpa_min"));
                p.setNumeroScarpaMax(rs.getInt("numero_scarpa_max"));
                p.setGenere(rs.getString("genere"));
                p.setImmagine(rs.getString("immagine"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setAttivo(rs.getBoolean("attivo"));
                p.setDataCreazione(rs.getTimestamp("data_creazione"));

                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public Product doRetrieveById(int id) 
    {
        String sql = "SELECT * FROM products WHERE id = ?";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Product p = new Product();

                p.setId(rs.getInt("id"));
                p.setNome(rs.getString("nome"));
                p.setDescrizione(rs.getString("descrizione"));
                p.setMarca(rs.getString("marca"));
                p.setPrezzo(rs.getDouble("prezzo"));
                p.setQuantitaDisponibile(rs.getInt("quantita_disponibile"));
                p.setNumeroScarpaMin(rs.getInt("numero_scarpa_min"));
                p.setNumeroScarpaMax(rs.getInt("numero_scarpa_max"));
                p.setGenere(rs.getString("genere"));
                p.setImmagine(rs.getString("immagine"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setAttivo(rs.getBoolean("attivo"));
                p.setDataCreazione(rs.getTimestamp("data_creazione"));

                return p;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<Product> doRetrieveByName(String name) 
    {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE nome LIKE ? AND attivo = TRUE";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + name + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();

                p.setId(rs.getInt("id"));
                p.setNome(rs.getString("nome"));
                p.setPrezzo(rs.getDouble("prezzo"));
                p.setImmagine(rs.getString("immagine"));

                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Product> doRetrieveByCategory(int categoryId) 
    {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category_id = ? AND attivo = TRUE";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();

                p.setId(rs.getInt("id"));
                p.setNome(rs.getString("nome"));
                p.setPrezzo(rs.getDouble("prezzo"));
                p.setImmagine(rs.getString("immagine"));

                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public void doSave(Product p) 
    {
        String sql = "INSERT INTO products "
                + "(nome, descrizione, marca, prezzo, quantita_disponibile, "
                + "numero_scarpa_min, numero_scarpa_max, genere, immagine, category_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, p.getNome());
            ps.setString(2, p.getDescrizione());
            ps.setString(3, p.getMarca());
            ps.setDouble(4, p.getPrezzo());
            ps.setInt(5, p.getQuantitaDisponibile());
            ps.setInt(6, p.getNumeroScarpaMin());
            ps.setInt(7, p.getNumeroScarpaMax());
            ps.setString(8, p.getGenere());
            ps.setString(9, p.getImmagine());
            ps.setInt(10, p.getCategoryId());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void doUpdate(Product p) 
    {
        String sql = "UPDATE products SET "
                + "nome = ?, descrizione = ?, marca = ?, prezzo = ?, quantita_disponibile = ?, "
                + "numero_scarpa_min = ?, numero_scarpa_max = ?, genere = ?, immagine = ?, category_id = ?, attivo = ? "
                + "WHERE id = ?";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, p.getNome());
            ps.setString(2, p.getDescrizione());
            ps.setString(3, p.getMarca());
            ps.setDouble(4, p.getPrezzo());
            ps.setInt(5, p.getQuantitaDisponibile());
            ps.setInt(6, p.getNumeroScarpaMin());
            ps.setInt(7, p.getNumeroScarpaMax());
            ps.setString(8, p.getGenere());
            ps.setString(9, p.getImmagine());
            ps.setInt(10, p.getCategoryId());
            ps.setBoolean(11, p.isAttivo());
            ps.setInt(12, p.getId());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateQuantity(int productId, int quantity) 
    {
        String sql = "UPDATE products SET quantita_disponibile = ? WHERE id = ?";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, productId);

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void doDelete(int id) 
    {
        String sql = "UPDATE products SET attivo = FALSE WHERE id = ?";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
