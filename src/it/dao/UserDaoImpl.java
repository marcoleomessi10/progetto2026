package it.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.sql.DataSource;

import it.model.User;

public class UserDaoImpl implements UserDao {

    private DataSource ds;

    public UserDaoImpl(DataSource ds) 
    {
        this.ds = ds;
    }

    @Override
    public User doRetrieveByEmailPassword(String email, String passwordHash) 
    {
        String sql = "SELECT * FROM users WHERE email = ? AND password_hash = ?";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, passwordHash);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User u = new User();

                u.setId(rs.getInt("id"));
                u.setNome(rs.getString("nome"));
                u.setCognome(rs.getString("cognome"));
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setTelefono(rs.getString("telefono"));
                u.setRuolo(rs.getString("ruolo"));
                u.setDataRegistrazione(rs.getTimestamp("data_registrazione"));

                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public User doRetrieveByEmail(String email) 
    {
        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User u = new User();

                u.setId(rs.getInt("id"));
                u.setEmail(rs.getString("email"));

                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public void doSave(User u) 
    {
        String sql = "INSERT INTO users "
                + "(nome, cognome, email, password_hash, telefono, ruolo) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, u.getNome());
            ps.setString(2, u.getCognome());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getPasswordHash());
            ps.setString(5, u.getTelefono());
            ps.setString(6, "CLIENTE");

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
