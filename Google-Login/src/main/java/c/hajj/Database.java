/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package m.dekmak;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import static java.time.Instant.now;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import javax.activation.DataSource;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import org.json.JSONArray;
import org.json.JSONObject;
import static org.json.JSONObject.NULL;

/**
 *
 * @author mdekmak
 */
public class Database {

    public static final String MYSQL_DRIVER = "com.mysql.jdbc.Driver";

    private Connection connection;
    private Statement statement;
    private ResultSet resultSet;
    private PreparedStatement preparedStatement;

    public Database() throws ClassNotFoundException, SQLException, NamingException {
        String dbName = getContextValue("jdbcDbName");
        String dbUser = getContextValue("jdbcDbUser");
        String dbUserPass = getContextValue("jdbcDbUserPass");
        String MYSQL_URL = "jdbc:mysql://localhost/" + dbName + "?user=" + dbUser + "&password=" + dbUserPass;
        Class.forName(MYSQL_DRIVER);
        connection = DriverManager.getConnection(MYSQL_URL);
    }

    public String getContextValue(String param) throws NamingException {
        // Get the base naming context
        Context env = (Context) new InitialContext().lookup("java:comp/env");
        // Get a single value
        String dbhost = (String) env.lookup(param);
        return dbhost;
    }

    public String updateUserInfo(String user_name, String user_email, String user_google_id) {
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("update users set users.isGoogleAuth = ?, users.email = ?, users.userGoogleId = ? where users.user_name = ?");
            preparedStatement.setString(1, "yes");
            preparedStatement.setString(2, user_email);
            preparedStatement.setString(3, user_google_id);
            preparedStatement.setString(4, user_name);
            preparedStatement.executeUpdate();
        } catch (Exception e) {
            return "error";
        }
        return "success";
    }

    public String[] getUserCredentials(String user_email, String user_google_id) {
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select user_name, password, pass2 from users where isGoogleAuth = ? AND email = ? AND userGoogleId = ?");
            preparedStatement.setString(1, "yes");
            preparedStatement.setString(2, user_email);
            preparedStatement.setString(3, user_google_id);
            ResultSet rs = preparedStatement.executeQuery();
            String userName = "";
            String pass = "";
            String pass2 = "";
            while (rs.next()) {
                userName = rs.getString("user_name");
                pass = rs.getString("password");
                pass2 = rs.getString("pass2");
            }
            Encryptor encr = new Encryptor(pass);
            String pass2Clear = encr.decrypt(pass2);
            return new String[]{userName, pass2Clear};
        } catch (Exception e) {
            return new String[]{"Exception message" + e.getMessage()};
        }
    }

    public List<String> getUsersList() {
        List<String> users = new ArrayList<String>();
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select users.user_name, GROUP_CONCAT(users_roles.role_name SEPARATOR '; ') AS role_name, users.email, users.isGoogleAuth, \"*action*\" AS action, users.isBanned from users left join users_roles on users_roles.user_name = users.user_name group by users.user_name");
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                List<String> row = new ArrayList<String>();
                row.add(rs.getString("user_name"));
                row.add(rs.getString("role_name"));
                row.add(rs.getString("email"));
                row.add(rs.getString("isGoogleAuth"));
                row.add(rs.getString("isBanned"));
                row.add(rs.getString("action"));
                users.add(row.toString());
            }
        } catch (Exception e) {
            users.add("Exception message" + e.getMessage());
        }
        return users;
    }

    public String updateProfilePassword(String profileName, String oldPaswword, String newPassword) {
        String msg = "";
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select user_name, password from users where user_name = ?");
            preparedStatement.setString(1, profileName);
            ResultSet rs = preparedStatement.executeQuery();
            String userName = "";
            String pass = "";
            while (rs.next()) {
                userName = rs.getString("user_name");
                pass = rs.getString("password");
            }
            if (userName == "" || pass == "") {
                msg = "User does not matched in local database";
            } else {
                MD5Digest md5 = new MD5Digest();
                // check if old password is correct
                String hashPwd = md5.generate(oldPaswword);
                if (pass.equals(hashPwd)) {
                    // update user password in DB
                    hashPwd = md5.generate(newPassword);
                    Encryptor encr = new Encryptor(hashPwd);
                    String pass2 = encr.encrypt(newPassword);
                    statement = connection.createStatement();
                    preparedStatement = connection.prepareStatement("update users set users.password = ?, pass2 = ?, flagChangePass = ? where users.user_name = ?");
                    preparedStatement.setString(1, hashPwd);
                    preparedStatement.setString(2, pass2);
                    preparedStatement.setString(3, "no");
                    preparedStatement.setString(4, profileName);
                    if (preparedStatement.executeUpdate() == 0) {
                        msg = "Failed to change user password (db problem)";
                    } else {
                        msg = "success";
                    }
                } else {
                    msg = "Old password does not matched in local database";
                }
            }
        } catch (Exception e) {
            msg = "Exception message: " + e.getMessage();
        }
        return msg;
    }

    public String updateUserBannedStatus(String user_name, String isBanned) {
        String msg = "";
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("update users set users.isBanned = ? where users.user_name = ?");
            preparedStatement.setString(1, isBanned);
            preparedStatement.setString(2, user_name);
            if (preparedStatement.executeUpdate() == 0) {
                msg = "Failed to change user banned status (db problem)";
            } else {
                msg = "success";
            }
        } catch (Exception e) {
            msg = "Exception message: " + e.getMessage();
        }
        return msg;
    }

    public String updateUserPassword(String user_name, String password) {
        String msg = "";
        try {
            MD5Digest md5 = new MD5Digest();
            String hashPwd = md5.generate(password);
            Encryptor encr = new Encryptor(hashPwd);
            String pass2 = encr.encrypt(password);
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("update users set users.password = ?, pass2 = ? where users.user_name = ?");
            preparedStatement.setString(1, hashPwd);
            preparedStatement.setString(2, pass2);
            preparedStatement.setString(3, user_name);
            if (preparedStatement.executeUpdate() == 0) {
                msg = "Failed to change user password (db problem)";
            } else {
                msg = "success";
            }
        } catch (Exception e) {
            msg = "Exception message: " + e.getMessage();
        }
        return msg;
    }

    public String editUser(String oldUsername, String newUsername, JSONObject newRoles) {
        String msg = "";
        try {
            int completeScript = 1;
            int updateUsername = 0;
            statement = connection.createStatement();

            // check if username has changed and the new value is already taken and exists in db. else, update username in db  
            if (!oldUsername.equals(newUsername)) {
                preparedStatement = connection.prepareStatement("select user_name from users where user_name = ?");
                preparedStatement.setString(1, newUsername);
                ResultSet rs = preparedStatement.executeQuery();
                String dbUserName = "";
                while (rs.next()) {
                    dbUserName = rs.getString("user_name");
                }
                if (dbUserName != "") { // new username already exists in DB
                    msg = "The new username already taken. Please choose another";
                    completeScript = 0;
                } else {
                    updateUsername = 1;
                }
            }
            if (completeScript == 1) {
                // remove old roles
                statement = connection.createStatement();
                preparedStatement = connection.prepareStatement("delete from users_roles where users_roles.user_name = ?");
                preparedStatement.setString(1, oldUsername);
                if (preparedStatement.executeUpdate() == 0) {
                    msg = "Failed to change roles (db problem)";
                    completeScript = 0;
                } else {
                    msg = "success";
                    completeScript = 1;
                }
                if (completeScript == 1) {
                    if (updateUsername == 1) {
                        // update username in DB
                        statement = connection.createStatement();
                        preparedStatement = connection.prepareStatement("update users set users.user_name = ? where users.user_name = ?");
                        preparedStatement.setString(1, newUsername);
                        preparedStatement.setString(2, oldUsername);
                        if (preparedStatement.executeUpdate() == 0) {
                            msg = "Failed to change username (db problem)";
                            completeScript = 0;
                        } else {
                            msg = "success";
                            completeScript = 1;
                        }
                    }
                    if (completeScript == 1) {
                        // insert new roles
                        Iterator<?> roles = newRoles.keys();
                        while (roles.hasNext()) {
                            String role = (String) roles.next();
                            statement = connection.createStatement();
                            preparedStatement = connection.prepareStatement("INSERT INTO users_roles"
                                    + "(user_name, role_name) VALUES"
                                    + "(?,?)");
                            preparedStatement.setString(1, newUsername);
                            preparedStatement.setString(2, role);
                            preparedStatement.executeUpdate();
                        }
                    }
                }
            }
        } catch (Exception e) {
            msg = "Exception message: " + e.getMessage();
        }
        return msg;
    }

    public int getActiveUsers() {
        int nb = 0;
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select count(*) from users where isBanned = ?");
            preparedStatement.setString(1, "no");
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                nb = rs.getInt(1);
            }
        } catch (Exception e) {
        }
        return nb;
    }

    public String addUser(String user_name, JSONObject user_groups, String password) {
        String msg = "";
        int completeScript = 1;
        try {
            MD5Digest md5 = new MD5Digest();
            String hashPwd = md5.generate(password);
            Encryptor encr = new Encryptor(hashPwd);
            String pass2 = encr.encrypt(password);
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select user_name from users where user_name = ?");
            preparedStatement.setString(1, user_name);
            ResultSet rs = preparedStatement.executeQuery();
            String dbUserName = "";
            while (rs.next()) {
                dbUserName = rs.getString("user_name");
            }
            if (dbUserName != "") { // username already exists in DB
                msg = "Username already taken. Please choose another";
                completeScript = 0;
            } else {
                preparedStatement = connection.prepareStatement("INSERT INTO users"
                        + "(user_name, password, pass2) VALUES"
                        + "(?,?,?)");
                preparedStatement.setString(1, user_name);
                preparedStatement.setString(2, hashPwd);
                preparedStatement.setString(3, pass2);
                if (preparedStatement.executeUpdate() == 0) {
                    msg = "Failed to add user (db problem)";
                } else {
                    msg = "success";
                    // link roles
                    Iterator<?> roles = user_groups.keys();
                    while (roles.hasNext()) {
                        String role = (String) roles.next();
                        statement = connection.createStatement();
                        preparedStatement = connection.prepareStatement("INSERT INTO users_roles"
                                + "(user_name, role_name) VALUES"
                                + "(?,?)");
                        preparedStatement.setString(1, user_name);
                        preparedStatement.setString(2, role);
                        preparedStatement.executeUpdate();
                    }
                }
            }
        } catch (Exception e) {
            msg = "Exception message: " + e.getMessage();
        }
        return msg;
    }

    public List<String> getUserGroupsList() {
        List<String> users = new ArrayList<String>();
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select roles.role_name, \"*action*\" AS action from roles");
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                List<String> row = new ArrayList<String>();
                row.add(rs.getString("role_name"));
                row.add(rs.getString("action"));
                users.add(row.toString());
            }
        } catch (Exception e) {
            users.add("Exception message" + e.getMessage());
        }
        return users;
    }

    public String addUserGroup(String name) {
        String msg = "";
        int completeScript = 1;
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select role_name from roles where role_name = ?");
            preparedStatement.setString(1, name);
            ResultSet rs = preparedStatement.executeQuery();
            String dbGroupName = "";
            while (rs.next()) {
                dbGroupName = rs.getString("role_name");
            }
            if (dbGroupName != "") { // username already exists in DB
                msg = "Group name already taken. Please choose another";
                completeScript = 0;
            } else {
                preparedStatement = connection.prepareStatement("INSERT INTO roles"
                        + "(role_name) VALUES"
                        + "(?)");
                preparedStatement.setString(1, name);
                if (preparedStatement.executeUpdate() == 0) {
                    msg = "Failed to add user group (db problem)";
                } else {
                    msg = "success";
                }
            }

        } catch (Exception e) {
            msg = "Exception message: " + e.getMessage();
        }
        return msg;
    }

    public String editUserGroup(String oldName, String newName) {
        String msg = "";
        try {
            int completeScript = 1;
            statement = connection.createStatement();
            // check if name has changed and the new value is already taken and exists in db. else, update name in db  
            if (!oldName.equals(newName)) {
                preparedStatement = connection.prepareStatement("select role_name from roles where role_name = ?");
                preparedStatement.setString(1, newName);
                ResultSet rs = preparedStatement.executeQuery();
                String dbName = "";
                while (rs.next()) {
                    dbName = rs.getString("role_name");
                }
                if (dbName != "") { // new name already exists in DB
                    completeScript = 0;
                }
            }
            if (completeScript == 1) {
                // check if new name is equal the static roles (list of static roles not editable)
                ConfigProperties confProp = new ConfigProperties();
                String userGroupsNotEditable = confProp.getPropValue("userGroupsNotEditable");
                String[] params = userGroupsNotEditable.split(",");
                outerloop:
                for (int j = 0; j < params.length; j++) {
                    String text = params[j];

                    if (text.startsWith("[")) {
                        text = text.substring(1);
                    }
                    if (text.endsWith("]")) {
                        text = text.substring(0, text.length() - 1);
                    }
                    text = text.substring(1);
                    text = text.substring(0, text.length() - 1);
                    if (text.equals(newName)) {
                        completeScript = 0;
                        break outerloop;
                    } else if (text.equals(oldName)) {
                        completeScript = 0;
                        break outerloop;
                    }
                }
                if (completeScript == 1) {
                    // select related users to be stored, then remove the relation of old role
                    // and insert the new relations of users with the new role
                    statement = connection.createStatement();
                    preparedStatement = connection.prepareStatement("select user_name from users_roles where role_name = ?");
                    preparedStatement.setString(1, oldName);
                    ResultSet rs = preparedStatement.executeQuery();
                    String dbUserName = "";
                    ArrayList<String> dbUsers = new ArrayList<String>();
                    while (rs.next()) {
                        dbUserName = rs.getString("user_name");
                        dbUsers.add(dbUserName);
                    }
                    if (dbUsers.isEmpty()) { // old group did not have relations with users
                        // update new name in roles table
                        statement = connection.createStatement();
                        preparedStatement = connection.prepareStatement("update roles set roles.role_name = ? where roles.role_name = ?");
                        preparedStatement.setString(1, newName);
                        preparedStatement.setString(2, oldName);
                        if (preparedStatement.executeUpdate() == 0) {
                            msg = "Failed to change name (db problem)";
                        } else {
                            msg = "success";
                        }
                    } else { // old group has relations with users
                        statement = connection.createStatement();
                        preparedStatement = connection.prepareStatement("delete from users_roles where users_roles.role_name = ?");
                        preparedStatement.setString(1, oldName);
                        if (preparedStatement.executeUpdate() == 0) {
                            msg = "Failed to remove old relations (db problem)";
                        } else {
                            // update new name in roles table
                            statement = connection.createStatement();
                            preparedStatement = connection.prepareStatement("update roles set roles.role_name = ? where roles.role_name = ?");
                            preparedStatement.setString(1, newName);
                            preparedStatement.setString(2, oldName);
                            if (preparedStatement.executeUpdate() == 0) {
                                msg = "Failed to change name (db problem)";
                            } else {
                                for (String user : dbUsers) {
                                    statement = connection.createStatement();
                                    preparedStatement = connection.prepareStatement("INSERT INTO users_roles"
                                            + "(user_name, role_name) VALUES"
                                            + "(?,?)");
                                    preparedStatement.setString(1, user);
                                    preparedStatement.setString(2, newName);
                                    preparedStatement.executeUpdate();
                                }
                                msg = "success";
                            }
                        }
                    }
                } else {
                    msg = "Please choose another group name, this group is related to system groups";
                }
            } else {
                msg = "The new name already taken. Please choose another";
            }
        } catch (Exception e) {
            msg = "Exception message: " + e.getMessage();
        }
        return msg;
    }

    public String[] getUserDetails(String user_email) {
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select user_name, isGoogleAuth, email from users where user_name = ?");
            preparedStatement.setString(1, user_email);
            ResultSet rs = preparedStatement.executeQuery();
            String userName = "";
            String isGoogleAuth = "";
            String email = "";
            while (rs.next()) {
                userName = rs.getString("user_name");
                isGoogleAuth = rs.getString("isGoogleAuth");
                email = rs.getString("email");
            }
            return new String[]{userName, isGoogleAuth, email};
        } catch (Exception e) {
            return new String[]{"Exception message" + e.getMessage()};
        }
    }

    public String disconnectGoogleAccount(String user_name) {
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("update users set users.isGoogleAuth = ?, users.email = ?, users.userGoogleId = ? where users.user_name = ?");
            preparedStatement.setString(1, "no");
            preparedStatement.setString(2, "");
            preparedStatement.setString(3, "");
            preparedStatement.setString(4, user_name);
            preparedStatement.executeUpdate();
        } catch (Exception e) {
            return "Exception message" + e.getMessage();
        }
        return "success";
    }

    public String userIsBanned(String user_email) {
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select isBanned from users where user_name = ?");
            preparedStatement.setString(1, user_email);
            ResultSet rs = preparedStatement.executeQuery();
            String isBanned = "";
            while (rs.next()) {
                isBanned = rs.getString("isBanned");
            }
            return isBanned;
        } catch (Exception e) {
            return "";
        }
    }

    public String notifyUser(String message, JSONObject users_list, String sendByEmail) {
        String msg = "";
        try {
            msg = "success";
            Iterator<?> users = users_list.keys();
            while (users.hasNext()) {
                String user = (String) users.next();
                statement = connection.createStatement();
                preparedStatement = connection.prepareStatement("INSERT INTO notifications"
                        + "(message, user_name, status, sentDate) VALUES"
                        + "(?,?,?,?)");
                message = message.replaceAll(",", "&comma&");
                preparedStatement.setString(1, message);
                preparedStatement.setString(2, user);
                preparedStatement.setString(3, "unseen");
                preparedStatement.setDate(4, getCurrentDate());
                preparedStatement.executeUpdate();
                if (sendByEmail.equals("yes")) {
                    statement = connection.createStatement();
                    preparedStatement = connection.prepareStatement("select email from users where user_name = ?");
                    preparedStatement.setString(1, user);
                    ResultSet rs = preparedStatement.executeQuery();
                    while (rs.next()) {
                        String userEmail = rs.getString("email");
                        if (userEmail != null && !userEmail.isEmpty()) {
                            Email email = new Email();
                            message = message.replaceAll("&comma&", ",");
                            msg = email.send(userEmail, message);
                            if (msg.equals("Done")) {
                                msg = "success";
                            }
                        }
                    }
                }
            }

        } catch (Exception e) {
            msg = "Exception message: " + e.getMessage();
        }
        return msg;
    }

    private static java.sql.Date getCurrentDate() {
        java.util.Date today = new java.util.Date();
        return new java.sql.Date(today.getTime());
    }

    public List<String> getNotificationsList(String user_name) {
        List<String> notifications = new ArrayList<String>();
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select message, sentDate, status from notifications where user_name = ? order by sentDate desc");
            preparedStatement.setString(1, user_name);
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                List<String> row = new ArrayList<String>();
                row.add(rs.getString("message"));
                row.add(rs.getString("sentDate"));
                row.add(rs.getString("status"));
                notifications.add(row.toString());
            }
        } catch (Exception e) {
            notifications.add("Exception message" + e.getMessage());
        }
        return notifications;
    }

    public List<String> getPendingNotifications(String user_name) {
        List<String> notifications = new ArrayList<String>();
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select id, message, sentDate from notifications where user_name = ? and status = ? order by sentDate desc limit 5");
            preparedStatement.setString(1, user_name);
            preparedStatement.setString(2, "unseen");
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                List<String> row = new ArrayList<String>();
                row.add(rs.getString("message"));
                row.add(rs.getString("sentDate"));
                notifications.add(row.toString());
                statement = connection.createStatement();
                preparedStatement = connection.prepareStatement("update notifications set status = ? where id = ?");
                preparedStatement.setString(1, "seen");
                preparedStatement.setString(2, rs.getString("id"));
                preparedStatement.executeUpdate();
            }
        } catch (Exception e) {
            notifications.add("Exception message" + e.getMessage());
        }
        return notifications;
    }

    public String getCounterNotifications(String user_name) {
        String nb = "";
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select count(*) from notifications where user_name = ? and status = ?");
            preparedStatement.setString(1, user_name);
            preparedStatement.setString(2, "unseen");
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                nb = rs.getString(1);
            }
        } catch (Exception e) {
        }
        return nb;
    }

    public String updateSystemPreferencesKey(String sysKey, String sysValue) {
        try {
            if (sysKey.equals("smtpPassword")) {
                Encryptor encr = new Encryptor();
                sysValue = encr.encrypt(sysValue);
            }
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("update system_preferences set sysValue = ? where sysKey = ?");
            preparedStatement.setString(1, sysValue);
            preparedStatement.setString(2, sysKey);
            preparedStatement.executeUpdate();
        } catch (Exception e) {
            return "Exception message" + e.getMessage();
        }
        return "success";
    }

    public String getSystemPreferencesValue(String sysKey) {
        String resp = "";
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select sysValue from system_preferences where sysKey = ?");
            preparedStatement.setString(1, sysKey);
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                resp = rs.getString("sysValue");
                if (sysKey.equals("smtpPassword")) {
                    Encryptor encr = new Encryptor();
                    resp = encr.decrypt(resp);
                }
            }
        } catch (Exception e) {
        }
        return resp;
    }

    public String addContact(JSONObject postData, String loggedUser) {
        String msg = "";
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("INSERT INTO contacts"
                    + "(firstName,lastName,title,gender,jobTitle,email,dateOfBirth,"
                    + "mobile,phone,fax,address1,address2,city,state,country,zip,"
                    + "createdBy,createdOn) VALUES"
                    + "(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
            preparedStatement.setString(1, postData.getString("firstName").replaceAll(",", "&comma&"));
            preparedStatement.setString(2, postData.getString("lastName").replaceAll(",", "&comma&"));
            preparedStatement.setString(3, postData.getString("title").replaceAll(",", "&comma&"));
            preparedStatement.setString(4, postData.getString("gender").replaceAll(",", "&comma&"));
            preparedStatement.setString(5, postData.getString("jobTitle").replaceAll(",", "&comma&"));
            preparedStatement.setString(6, postData.getString("email").replaceAll(",", "&comma&"));
            preparedStatement.setString(7, postData.getString("dateOfBirth").replaceAll(",", "&comma&"));
            preparedStatement.setString(8, postData.getString("mobile").replaceAll(",", "&comma&"));
            preparedStatement.setString(9, postData.getString("phone").replaceAll(",", "&comma&"));
            preparedStatement.setString(10, postData.getString("fax").replaceAll(",", "&comma&"));
            preparedStatement.setString(11, postData.getString("address1").replaceAll(",", "&comma&"));
            preparedStatement.setString(12, postData.getString("address2").replaceAll(",", "&comma&"));
            preparedStatement.setString(13, postData.getString("city").replaceAll(",", "&comma&"));
            preparedStatement.setString(14, postData.getString("state").replaceAll(",", "&comma&"));
            preparedStatement.setString(15, postData.getString("country").replaceAll(",", "&comma&"));
            preparedStatement.setString(16, postData.getString("zip").replaceAll(",", "&comma&"));
            preparedStatement.setString(17, loggedUser);
            preparedStatement.setDate(18, getCurrentDate());
            if (preparedStatement.executeUpdate() == 0) {
                msg = "Failed to add contact (db problem)";
            } else {
                msg = "success";
            }

        } catch (Exception e) {
            msg = "Exception message: " + e.getMessage();
        }
        return msg;
    }

    public List<String> loadContact(String id) {
        List<String> data = new ArrayList<String>();
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select contacts.* from contacts where id = ?");
            preparedStatement.setString(1, id);
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                List<String> row = new ArrayList<String>();
                row.add(rs.getString("firstName"));
                row.add(rs.getString("lastName"));
                row.add(rs.getString("title"));
                row.add(rs.getString("gender"));
                row.add(rs.getString("jobTitle"));
                row.add(rs.getString("email"));
                row.add(rs.getString("dateOfBirth"));
                row.add(rs.getString("mobile"));
                row.add(rs.getString("phone"));
                row.add(rs.getString("fax"));
                row.add(rs.getString("address1"));
                row.add(rs.getString("address2"));
                row.add(rs.getString("city"));
                row.add(rs.getString("state"));
                row.add(rs.getString("country"));
                row.add(rs.getString("zip"));
                data.add(row.toString());
            }
        } catch (Exception e) {
            data.add("Exception message" + e.getMessage());
        }
        return data;
    }

    public String editContact(String id, JSONObject postData, String loggedUser) {
        String msg = "";
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("update contacts set "
                    + "firstName = ?, lastName = ?, title = ?, gender = ?, jobTitle = ?, "
                    + "email = ?, dateOfBirth = ?, mobile = ?, phone = ?, fax = ?, "
                    + "address1 = ?, address2 = ?, city = ?, state = ?, country = ?,"
                    + "zip = ?, modifiedBy = ?, modifiedOn = ? "
                    + "Where id = ?");
            preparedStatement.setString(1, postData.getString("firstName").replaceAll(",", "&comma&"));
            preparedStatement.setString(2, postData.getString("lastName").replaceAll(",", "&comma&"));
            preparedStatement.setString(3, postData.getString("title").replaceAll(",", "&comma&"));
            preparedStatement.setString(4, postData.getString("gender").replaceAll(",", "&comma&"));
            preparedStatement.setString(5, postData.getString("jobTitle").replaceAll(",", "&comma&"));
            preparedStatement.setString(6, postData.getString("email").replaceAll(",", "&comma&"));
            preparedStatement.setString(7, postData.getString("dateOfBirth").replaceAll(",", "&comma&"));
            preparedStatement.setString(8, postData.getString("mobile").replaceAll(",", "&comma&"));
            preparedStatement.setString(9, postData.getString("phone").replaceAll(",", "&comma&"));
            preparedStatement.setString(10, postData.getString("fax").replaceAll(",", "&comma&"));
            preparedStatement.setString(11, postData.getString("address1").replaceAll(",", "&comma&"));
            preparedStatement.setString(12, postData.getString("address2").replaceAll(",", "&comma&"));
            preparedStatement.setString(13, postData.getString("city").replaceAll(",", "&comma&"));
            preparedStatement.setString(14, postData.getString("state").replaceAll(",", "&comma&"));
            preparedStatement.setString(15, postData.getString("country").replaceAll(",", "&comma&"));
            preparedStatement.setString(16, postData.getString("zip").replaceAll(",", "&comma&"));
            preparedStatement.setString(17, loggedUser);
            preparedStatement.setDate(18, getCurrentDate());
            preparedStatement.setString(19, id);
            if (preparedStatement.executeUpdate() == 0) {
                msg = "Failed to edit contact (db problem)";
            } else {
                msg = "success";
            }

        } catch (Exception e) {
            msg = "Exception message: " + e.getMessage();
        }
        return msg;
    }

    public List<String> getContactsList() {
        List<String> contacts = new ArrayList<String>();
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select id, firstName, lastName, email, mobile, phone, \"*action*\" AS action from contacts");
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                List<String> row = new ArrayList<String>();
                row.add(rs.getString("id"));
                row.add(rs.getString("firstName"));
                row.add(rs.getString("lastName"));
                row.add(rs.getString("email"));
                row.add(rs.getString("mobile"));
                row.add(rs.getString("phone"));
                row.add(rs.getString("action"));
                contacts.add(row.toString());
            }
        } catch (Exception e) {
            contacts.add("Exception message" + e.getMessage());
        }
        return contacts;
    }

    public int getTotalBannedUsers() {
        int nb = 0;
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select count(*) from users where isBanned = ?");
            preparedStatement.setString(1, "yes");
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                nb = rs.getInt(1);
            }
        } catch (Exception e) {
        }
        return nb;
    }

    public int getTotalUsers() {
        int nb = 0;
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select count(*) from users");
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                nb = rs.getInt(1);
            }
        } catch (Exception e) {
        }
        return nb;
    }

    public List<String> getUsersListPerGroups() {
        List<String> groups = new ArrayList<String>();
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select users_roles.role_name as role, count(users.user_name) as countUsers from users left join users_roles on users_roles.user_name = users.user_name group by users_roles.role_name");
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                List<String> row = new ArrayList<String>();
                row.add(rs.getString("role"));
                row.add(rs.getString("countUsers"));
                groups.add(row.toString());
            }
        } catch (Exception e) {
        }
        return groups;
    }

    public String flagChangeUserPass(String user_name) {
        String msg = "";
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("update users set users.flagChangePass = ? where users.user_name = ?");
            preparedStatement.setString(1, "yes");
            preparedStatement.setString(2, user_name);
            if (preparedStatement.executeUpdate() == 0) {
                msg = "Failed to flag user (db problem)";
            } else {
                msg = "success";
            }
        } catch (Exception e) {
            msg = "Exception message: " + e.getMessage();
        }
        return msg;
    }

    public String checkUserFlagChangePwd(String user_name) {
        String flag = "";
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select flagChangePass from users where user_name = ?");
            preparedStatement.setString(1, user_name);
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                flag = rs.getString("flagChangePass");
            }
        } catch (Exception e) {
            flag = e.getMessage();
        }
        return flag;
    }

    public int addEvent(String title, String start, String end, String location, JSONObject users, String createdBy) {
        int id = 0;
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("INSERT INTO calendar"
                    + "(title, start, end, location, createdBy) VALUES"
                    + "(?,?,?,?,?)");
            preparedStatement.setString(1, title.replaceAll(",", "&comma&"));
            preparedStatement.setString(2, start);
            preparedStatement.setString(3, end);
            preparedStatement.setString(4, location.replaceAll(",", "&comma&"));
            preparedStatement.setString(5, createdBy);
            int affectedRows = preparedStatement.executeUpdate();
            if (affectedRows != 0) {
                ResultSet generatedKeys = preparedStatement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    id = (int) generatedKeys.getLong(1);
                    Iterator<?> invities = users.keys();
                    while (invities.hasNext()) {
                        String user = (String) invities.next();
                        statement = connection.createStatement();
                        preparedStatement = connection.prepareStatement("INSERT INTO calendar_users"
                                + "(event_id, user_name) VALUES"
                                + "(?,?)");
                        preparedStatement.setInt(1, id);
                        preparedStatement.setString(2, user);
                        if (preparedStatement.executeUpdate() != 0) {
                            statement = connection.createStatement();
                            preparedStatement = connection.prepareStatement("select email from users where user_name = ?");
                            preparedStatement.setString(1, user);
                            ResultSet rs = preparedStatement.executeQuery();
                            while (rs.next()) {
                                String userEmail = rs.getString("email");
                                if (userEmail != null && !userEmail.isEmpty()) {
                                    Email email = new Email();
                                    String message = "Hi " + user + ",\n\n"
                                            + "You have invited to the below event: \n\n"
                                            + "Title: " + title.replaceAll("&comma&", ",") + "\n"
                                            + "Start date: " + start + "\n"
                                            + "End date: " + end + "\n"
                                            + "Location: " + location;
                                    String msg = email.send(userEmail, message);
                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
        }
        return id;
    }

    public JSONObject readEvents(JSONObject users) {
        JSONObject jsO = new JSONObject();
        try {
            StringBuilder inClause = new StringBuilder();
            Iterator<?> invities = users.keys();
            while (invities.hasNext()) {
                String user = (String) invities.next();
                inClause.append('?');
                inClause.append(',');
            }
            if (inClause.length() > 0) {
                inClause.setLength(inClause.length() - 1);
            }
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("select * from calendar left join calendar_users on calendar_users.event_id = calendar.id where id >= ? AND calendar_users.user_name in (" + inClause.toString() + ") group by calendar_users.event_id");
            preparedStatement.setInt(1, 1);
            Iterator<?> invitiesList = users.keys();
            int i = 2;
            while (invitiesList.hasNext()) {
                String user = (String) invitiesList.next();
                preparedStatement.setString(i, user);
                i++;
            }
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                JSONObject jsO2 = new JSONObject();
                jsO2.put("id", rs.getString("id"));
                jsO2.put("title", rs.getString("title"));
                jsO2.put("start", rs.getString("start"));
                jsO2.put("end", rs.getString("end"));
                jsO2.put("location", rs.getString("location"));
                jsO.put(rs.getString("id"), jsO2);
            }
        } catch (Exception e) {
        }
        return jsO;
    }

    public String editEvent(String id, String start, String end) {
        String msg = "";
        try {
            statement = connection.createStatement();
            preparedStatement = connection.prepareStatement("update calendar set start = ?, end = ? where id = ?");
            preparedStatement.setString(1, start);
            preparedStatement.setString(2, end);
            preparedStatement.setString(3, id);
            if (preparedStatement.executeUpdate() == 0) {
                msg = "Failed to edit event (db problem)";
            } else {
                msg = "success";
                statement = connection.createStatement();
                preparedStatement = connection.prepareStatement("select users.email, users.user_name, calendar.title, calendar.location from users left join calendar_users on calendar_users.user_name = users.user_name AND calendar_users.event_id = ? left join calendar on calendar.id = calendar_users.event_id");
                preparedStatement.setString(1, id);
                ResultSet rs = preparedStatement.executeQuery();
                while (rs.next()) {
                    String userEmail = rs.getString("email");
                    String user = rs.getString("user_name");
                    String title = rs.getString("title");
                    String location = rs.getString("location");
                    if (userEmail != null && !userEmail.isEmpty()) {
                        Email email = new Email();
                        String message = "Hi " + user + ",\n\n"
                                + "There are new changes on the below event: \n\n"
                                + "Title: " + title.replaceAll("&comma&", ",") + "\n"
                                + "Start date: " + start + "\n"
                                + "End date: " + end + "\n"
                                + "Location: " + location;
                        String emailMsg = email.send(userEmail, message);
                    }
                }

            }
        } catch (Exception e) {
            msg = "Exception message: " + e.getMessage();
        }
        return msg;
    }
}
