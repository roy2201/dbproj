package com.example.taxiandrentapp;

import com.example.taxiandrentapp.Database;

import java.sql.*;

public class AdminModel {

    public Database db;
    public Connection con;

    public AdminModel() {

        try {
            db = Database.getInstance();
            con = db.connect();
        } catch (SQLException e) {
            e.printStackTrace();
     }
    }

    public void addCar(String color, String year, String model, String type, String price, String penalty, String location, String cost) throws Exception {
        PreparedStatement ps;
        String query = "exec spAddCar ?,?,?,?,?,?,?,?";
        ps = con.prepareStatement(query);
        ps.setString(1,color);
        ps.setString(2,year);
        ps.setString(3,model);
        ps.setString(4,type);
        ps.setString(5,price);
        ps.setString(6,penalty);
        ps.setString(7,location);
        ps.setString(8,cost);
        if(ps.execute()) throw new Exception();
    }

}
