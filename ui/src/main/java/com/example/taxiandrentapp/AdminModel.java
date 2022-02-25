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

    public int addCar(String color, String year, String model, String type, String price, String penalty, String location, String cost) throws Exception {
        CallableStatement cst;
        String query = "exec spAddCar ?,?,?,?,?,?,?,?,?";
        cst = con.prepareCall(query);
        cst.setString(1,color);
        cst.setString(2,year);
        cst.setString(3,model);
        cst.setString(4,type);
        cst.setString(5,price);
        cst.setString(6,penalty);
        cst.setString(7,location);
        cst.setString(8,cost);
        cst.registerOutParameter(9,Types.INTEGER);
        if(cst.execute()) throw new Exception();
        return cst.getInt(9);
    }

}
