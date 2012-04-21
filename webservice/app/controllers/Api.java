package controllers;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonParser;
import models.Checkin;
import play.db.jpa.JPABase;
import play.mvc.Controller;

import java.util.List;

/**
 * User: axelhzf
 */
public class Api extends Controller {

    public static void all(){
        List<Checkin> checkins = Checkin.findAll();
        renderJSON(getGson().toJson(checkins));
    }

    public static void create(String body){
        Checkin checkin = getGson().fromJson(body, Checkin.class);
        checkin.id = null;
        checkin.save();
    }

    static Gson getGson(){
        Gson gson = new GsonBuilder().setDateFormat("ddMMMyyyy HH:mm:ss").create();
        return gson;
    }

}
