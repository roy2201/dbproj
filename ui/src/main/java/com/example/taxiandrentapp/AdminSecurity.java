package com.example.taxiandrentapp;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.ComboBox;
import javafx.stage.Stage;

import java.io.IOException;
import java.net.URL;
import java.sql.*;
import java.util.ArrayList;
import java.util.ResourceBundle;

public class AdminSecurity implements Initializable {

    Connection con;

    @FXML
    private ComboBox<String> databasesComboBox;
    @FXML
    private ComboBox<String> tablesComboBox;
    @FXML
    private ComboBox<String> userRolesComboBox;

    public AdminSecurity() {
        Database db = null;
        try {
            db = Database.getInstance();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        assert null != db;
        con = db.connect();
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        loadDatabases();
        loadRoles();
    }

    public void loadDatabases() {
        String query = "exec spLoadDbNames";
        ArrayList<String> databases = new ArrayList<>();
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                databases.add(rs.getString(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        databasesComboBox.getItems().addAll(databases);
    }

    @FXML
    public void loadTables() {
        if(databasesComboBox.getSelectionModel().isEmpty()) return ;
        ArrayList<String> tables = new ArrayList<>();
        String dbName = databasesComboBox.getValue();
        String query = "exec spGetTableNames ?";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, dbName);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                tables.add(rs.getString(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        tablesComboBox.getItems().clear();
        tablesComboBox.getItems().addAll(tables);
    }

    public void loadRoles() {
        ArrayList<String> roles = new ArrayList<>();
        String query = "exec spLoadRoles";
        PreparedStatement ps = null;
        try {
            ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                roles.add(rs.getString(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        userRolesComboBox.getItems().addAll(roles);
    }

    @FXML
    public void secondAdminPage(ActionEvent event) {
        try {
            ((Node) event.getSource()).getScene().getWindow().hide();
            Stage stage = new Stage();
            FXMLLoader fxmlLoader = new FXMLLoader(HelloApplication.class.getResource("admin-view2.fxml"));
            Scene scene = new Scene(fxmlLoader.load());
            stage.setTitle("admin view 2");
            stage.setScene(scene);
            stage.show();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

