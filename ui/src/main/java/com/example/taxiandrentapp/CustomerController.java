package com.example.taxiandrentapp;

import javafx.beans.property.SimpleStringProperty;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.paint.Color;
import javafx.stage.Stage;
import javafx.util.Callback;

import java.io.IOException;
import java.net.URL;
import java.sql.*;
import java.util.ArrayList;
import java.util.ResourceBundle;

@SuppressWarnings("rawtypes")
public class CustomerController implements javafx.fxml.Initializable {

    @FXML
    private TableView carsTable;
    @FXML
    private TableView cardsAndRents;
    @FXML
    private TextField nbDaysTextField;
    @FXML
    private TextField carIdTextField;
    @FXML
    private TextField cardNumberTextField;
    @FXML
    private Label validDataLabel;
    @FXML
    private Label statusLabel;
    @FXML
    private ListView<String> receiptList;
    @FXML
    private TextField rentInfoIdTextField;
    @FXML
    private Label daysLeftLabel;
    @FXML
    private ComboBox<String> modelComboBox;
    @FXML
    private ComboBox<String> locationComboBox;
    @FXML
    private TextField emailTextField;
    @FXML
    private TextField rentIdTextField;
    @FXML
    private TextField cardTextField;
    @FXML
    private Label errorRequestLabel;
    @FXML
    private Label emailErrorLabel;
    @FXML
    private Label rentIdErrorLabel;
    @FXML
    private Label cardNumberErrorLabel;

    private ObservableList<ObservableList> data;
    private Connection con;
    private float total;

    private static final String TABLE_CAR = "tblCar";
    private static final String TABLE_BRANCH = "tblBranch";
    private static final String COL_PRICE = "Price";

    public CustomerController() {
        try {
            Database db = Database.getInstance();
            con = db.connect();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        try {
            loadAllCars();
            loadLocations();
            loadModels();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void removeLogin(int cid) {
        String query = "exec spLogOut ?";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, cid);
            ps.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @FXML
    public void signOutAction(ActionEvent event) {
        try {
            removeLogin(LoginModel.getLogged());
            ((Node) event.getSource()).getScene().getWindow().hide();
            Stage stage = new Stage();
            FXMLLoader fxmlLoader = new FXMLLoader(HelloApplication.class.getResource("hello-view.fxml"));
            Scene scene = new Scene(fxmlLoader.load());
            stage.setTitle("Login");
            stage.setScene(scene);
            stage.show();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public boolean checkPremium() {
        String query = "exec spCheckPremium ?, ?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setInt(1, LoginModel.getLogged());
            cst.registerOutParameter(2, Types.BOOLEAN);
            cst.execute();
            return cst.getBoolean(2);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @FXML
    public void viewReceiptAction() throws SQLException {
        receiptList.getItems().clear();
        if(carIdTextField.getText().isBlank() || nbDaysTextField.getText().isBlank()) {
            validDataLabel.setText("Blank input");
        } else {
            String query = "exec spViewReceipt ?, ?, ?, ?";
            CallableStatement cst = con.prepareCall(query);
            cst.setInt(1, Integer.parseInt(carIdTextField.getText()));
            cst.setInt(2, Integer.parseInt(nbDaysTextField.getText()));
            cst.registerOutParameter(3, Types.INTEGER);
            cst.registerOutParameter(4, Types.FLOAT);
            cst.execute();
            float price = cst.getFloat(4);
            int errorCode = cst.getInt(3);
            double discount;
            if (errorCode == 2) {
                validDataLabel.setText("Invalid Id");
                validDataLabel.setTextFill(Color.RED);
            } else {
                validDataLabel.setText("Valid Id");
                validDataLabel.setTextFill(Color.GREEN);
                receiptList.getItems().add("Price = " + price);
                boolean isPremium = checkPremium();
                if (!isPremium) {
                    discount = 0;
                    receiptList.getItems().add("No Premium (- 0%)");
                } else {
                    discount = (int) price * 0.25;
                    receiptList.getItems().add("Premium (- 25%) : - " + discount);
                    validDataLabel.setText("Valid");
                    validDataLabel.setTextFill(Color.GREEN);
                }
                receiptList.getItems().add("Total = " + (float) (price - discount));
                this.total = (float) (price - discount);
            }
        }
    }

    @FXML
    void viewCardsAction() {
        cardsAndRents.getColumns().clear();
        data = FXCollections.observableArrayList();
        String query = "exec spViewCards ?";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1,LoginModel.getLogged());
            ResultSet rs = ps.executeQuery();
            drawTable(rs, cardsAndRents);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @FXML
    public void viewRentsAction() {
        cardsAndRents.getColumns().clear();
        data = FXCollections.observableArrayList();
        String query = "exec spViewRents ?";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1,LoginModel.getLogged());
            ResultSet rs = ps.executeQuery();
            drawTable(rs, cardsAndRents);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @FXML
    public void payAction() throws SQLException {
        String cardNumber = cardNumberTextField.getText();
        int errorCode;
        if (cardNumber.isBlank()) {
            statusLabel.setText("Blank input");
            statusLabel.setTextFill(Color.RED);
        } else {
            //transaction
            String query = "exec spRentCar ?, ?, ?, ?, ?, ?";
            CallableStatement cs = con.prepareCall(query);
            cs.setInt(1,LoginModel.getLogged());
            cs.setFloat(2,total);
            cs.setInt(3,Integer.parseInt(cardNumber));
            cs.setInt(4,Integer.parseInt(carIdTextField.getText()));
            cs.setInt(5,Integer.parseInt(nbDaysTextField.getText()));
            cs.registerOutParameter(6,Types.INTEGER);
            System.out.println("executing ...");
            cs.execute();
            errorCode = cs.getInt(6);
            System.out.println("error code is "+errorCode);
            System.out.println("login is : "+ LoginModel.getLogged());
            System.out.println("card is "+ cardNumber);
            if(errorCode == 5) {
                statusLabel.setText("Insufficient amount");
                statusLabel.setTextFill(Color.RED);
            } else if (errorCode == 2){
                statusLabel.setText("Invalid Card");
                statusLabel.setTextFill(Color.ORANGE);
            } else if (errorCode == 1) {
                statusLabel.setText("Transaction succeed");
                statusLabel.setTextFill(Color.GREEN);
            } else if (errorCode == 3) {
                statusLabel.setText("sorry car is rented");
                statusLabel.setTextFill(Color.PURPLE);
            }
            cs.close();
            System.out.println("closing ...");
        }
    }

    @FXML
    public void checkDaysLeftAction() throws SQLException {
        int daysLeft;
        int errorCode;
        int rentId;
        float penalty;
        int daysOverDue;
        String str = rentInfoIdTextField.getText();
        if(str.isBlank()) {
            daysLeftLabel.setText("Invalid input");
            daysLeftLabel.setTextFill(Color.RED);
        } else {
            rentId = Integer.parseInt(str);
            String query = "exec spViewDaysLeft ?,?,?,?,?";
            CallableStatement cs = con.prepareCall(query);
            cs.setInt(1,rentId);
            cs.registerOutParameter(2,Types.INTEGER);
            cs.registerOutParameter(3,Types.INTEGER);
            cs.registerOutParameter(4,Types.FLOAT);
            cs.registerOutParameter(5, Types.INTEGER);
            cs.execute();
            daysLeft = cs.getInt(2);
            errorCode = cs.getInt(3);
            penalty = cs.getFloat(4);
            daysOverDue = cs.getInt(5);
            if(errorCode == 1) {
                daysLeftLabel.setText(daysLeft + " days left");
                System.out.println("errorCode : " + errorCode);
            }
            else if (errorCode == 3) {
                daysLeftLabel.setTextFill(Color.RED);
                daysLeftLabel.setText("overdue by "+ daysOverDue + " days" + "\n"+ "Penalty : "+penalty + " USD");
            } else if (errorCode == 2) {
                daysLeftLabel.setText("Rent doesn't exist");
            }
        }
    }

    public void loadModels() throws SQLException {
        ArrayList<String> models = new ArrayList<>();
        String query = "SELECT DISTINCT CAR_MODEL FROM " + TABLE_CAR;
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();
        while(rs.next()) {
            models.add(rs.getString("CAR_MODEL"));
        }
        modelComboBox.getItems().addAll(models);
    }

    public void loadLocations() throws SQLException {
        ArrayList<String> locations = new ArrayList<>();
        String query = "SELECT DISTINCT LOC_NAME FROM " + TABLE_BRANCH;
        PreparedStatement ps = con.prepareStatement(query);
        ResultSet rs = ps.executeQuery();
        while(rs.next()) {
            locations.add(rs.getString("LOC_NAME"));
        }
        locationComboBox.getItems().addAll(locations);
    }

    @FXML
    void filteredSearchAction() {
        carsTable.getColumns().clear();
        String query = "exec spViewMatchingCars ?, ?";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, modelComboBox.getValue());
            ps.setString(2, locationComboBox.getValue());
            ResultSet rs = ps.executeQuery();
            drawTable(rs, carsTable);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @FXML
    void initRequest() {
        errorRequestLabel.setText("");
        cardNumberErrorLabel.setText("");
        emailErrorLabel.setText("");
        rentIdErrorLabel.setText("");
        System.out.println("init .................");
        String query = "exec spInitRequest ?, ?, ?, ?, ?, ?, ?";
        try {
            CallableStatement cst = con.prepareCall(query);
            cst.setString(1, emailTextField.getText());
            cst.setInt(2, Integer.parseInt(rentIdTextField.getText()));
            cst.setInt(3, Integer.parseInt(cardTextField.getText()));
            cst.registerOutParameter(4, Types.INTEGER);
            cst.registerOutParameter(5, Types.INTEGER);
            cst.registerOutParameter(6, Types.INTEGER);
            cst.registerOutParameter(7, Types.INTEGER);
            cst.execute();
            int emailError = cst.getInt(4);
            int rentIdError = cst.getInt(5);
            int cardNumberError = cst.getInt(6);
            int errorCode = cst.getInt(7);
            if(errorCode == 1) {
                errorRequestLabel.setText("Request initiated");
                errorRequestLabel.setTextFill(Color.GREEN);
                emailErrorLabel.setText("Valid email");
                emailErrorLabel.setTextFill(Color.GREEN);
                rentIdErrorLabel.setText("Valid Rent Id");
                rentIdErrorLabel.setTextFill(Color.GREEN);
                cardNumberErrorLabel.setText("Valid card");
                cardNumberErrorLabel.setTextFill(Color.GREEN);
            } else {
                errorRequestLabel.setText("Error\nRequest Aborted");
                errorRequestLabel.setTextFill(Color.RED);
                if(emailError == 1) {
                    emailErrorLabel.setText("Invalid email");
                    emailErrorLabel.setTextFill(Color.RED);
                } else {
                    emailErrorLabel.setText("Valid email");
                    emailErrorLabel.setTextFill(Color.GREEN);
                }
                if(rentIdError == 1) {
                    rentIdErrorLabel.setText("Invalid Rent Id");
                    rentIdErrorLabel.setTextFill(Color.RED);
                } else {
                    rentIdErrorLabel.setText("Valid Rent Id");
                    rentIdErrorLabel.setTextFill(Color.GREEN);
                }
                if(cardNumberError == 1) {
                    cardNumberErrorLabel.setText("Invalid card");
                    cardNumberErrorLabel.setTextFill(Color.RED);
                } else {
                    cardNumberErrorLabel.setText("Valid card");
                    cardNumberErrorLabel.setTextFill(Color.GREEN);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @FXML
    void viewRequests() {
        cardsAndRents.getColumns().clear();
        String query = "exec spViewMyRequest ?";
        try{
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, LoginModel.getLogged());
            ResultSet rs = ps.executeQuery();
            drawTable(rs, cardsAndRents);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @FXML
    public void loadAllCars() {
        String query = "select * from vwCarsAndBranch";
        try {
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            drawTable(rs, carsTable);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @SuppressWarnings("all")
    void drawTable(ResultSet rs, TableView tableView) {
        tableView.getColumns().clear();
        data = FXCollections.observableArrayList();
        try {
            for (int i = 0; i < rs.getMetaData().getColumnCount(); i++) {
                final int j = i;
                TableColumn col = new TableColumn(rs.getMetaData().getColumnName(i + 1));
                col.setCellValueFactory((Callback<TableColumn.CellDataFeatures<ObservableList, String>, ObservableValue<String>>) param -> new SimpleStringProperty(param.getValue().get(j).toString()));
                tableView.getColumns().addAll(col);
                System.out.println("Column [" + i + "] ");
            }
            while (rs.next()) {
                ObservableList<String> row = FXCollections.observableArrayList();
                for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
                    row.add(rs.getString(i));
                }
                System.out.println("Row [1] added " + row);
                data.add(row);
                tableView.setItems(data);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}