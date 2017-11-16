package m.dekmak;

import org.json.JSONArray;
import org.json.JSONObject;

public class ConfigProperties {

    JSONObject propValues = new JSONObject();

    // @TO-DO: later on, we should read values from config.properties file in resources
    public ConfigProperties() {
        JSONArray staticGroups = new JSONArray();
        staticGroups.put("admin");
        staticGroups.put("user");
        staticGroups.put("manager");
        staticGroups.put("manager-gui");
        staticGroups.put("manager-script");
        
        propValues.put("appName", "SMB215 - Google Auth");
        propValues.put("appVersion", "v1.0");
        propValues.put("userGroupsNotEditable", (Object) staticGroups);

    }

    public String getPropValue(String prop) {
        return propValues.get(prop).toString();
    }
}
