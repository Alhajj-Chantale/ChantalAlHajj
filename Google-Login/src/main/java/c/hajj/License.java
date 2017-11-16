/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package m.dekmak;

import java.io.File;
import java.net.URL;
import java.io.FileReader;
import java.util.Iterator;

import org.json.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

/**
 *
 * @author mdekmak
 */
public class License {

    private String product = null;
    private String clientName = null;
    private String nbOfUsers = null;
    private String expiresOn = null;

    public void setProduct(String product) {
        this.product = product;
    }

    public String getProduct() {
        return this.product;
    }
    public void setClient(String client) {
        this.clientName = client;
    }

    public String getClient() {
        return this.clientName;
    }
    public void setExpiresOn(String expiresOn) {
        this.expiresOn = expiresOn;
    }

    public String getExpiresOn() {
        return this.expiresOn;
    }

    public void setNbOfUsers(String nbOfUsers) {
        this.nbOfUsers = nbOfUsers;
    }

    public String getNbOfUsers() {
        return this.nbOfUsers;
    }

    public String validate() {
        String msg = "";
        URL location = License.class.getProtectionDomain().getCodeSource().getLocation();
        String url = location.getFile();
        String path = url.substring(0, url.length() - 38);
        String licensePath = path + "license";
        File f = new File(licensePath);
        if (f.exists() && !f.isDirectory()) {
            JSONParser parser = new JSONParser();
            try {
                Object obj = parser.parse(new FileReader(licensePath));
                JSONObject jsonObject = (JSONObject) obj;
                String client = (String) jsonObject.get("client");
                if (client == null || client.equals("")) {
                    msg = "Invalid license (client not defined)";
                } else {
                    String product = (String) jsonObject.get("product");
                    if (product == null || product.equals("")) {
                        msg = "Invalid license (product not defined)";
                    } else {
                        String nbOfUsers = (String) jsonObject.get("nbOfUsers");
                        if (nbOfUsers == null || nbOfUsers.equals("")) {
                            msg = "Invalid license (Nb Of Users not defined)";
                        } else {
                            String expiresOn = (String) jsonObject.get("expiresOn");
                            if (expiresOn == null || expiresOn.equals("")) {
                                msg = "Invalid license (Expires on date not defined)";
                            } else {
                                Encryptor encr = new Encryptor(client);
                                String license = (String) jsonObject.get("license");
                                if (license == null || license.equals("")) {
                                    msg = "Invalid license (license not defined)";
                                } else {
                                    product = encr.decrypt(product);
                                    nbOfUsers = encr.decrypt(nbOfUsers);
                                    expiresOn = encr.decrypt(expiresOn);
                                    license = encr.decrypt(license);
                                    if (license.equals(client)) {
                                        setExpiresOn(expiresOn);
                                        setNbOfUsers(nbOfUsers);
                                        setClient(client);
                                        setProduct(product);
                                        msg = "success";
                                    }else{
                                        msg = "Invalid license";
                                    }
                                }
                            }
                        }
                    }
                }
            } catch (Exception e) {
                msg = "Invalid license for given client";
            }
        } else {
            msg = "License file not exists";
        }

        return msg;
    }
}
