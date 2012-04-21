package controllers;

import com.google.gson.Gson;
import com.google.gson.JsonParser;
import models.Checkin;
import play.db.jpa.JPABase;
import play.mvc.Controller;

import java.util.List;

/**
 * User: axelhzf
 */
public class Checkins extends Controller {

    public static void all(){
        List<Checkin> checkins = Checkin.findAll();
        renderJSON(checkins);
    }

    public static void create(String body){
        Checkin checkin = new Gson().fromJson(body, Checkin.class);
        checkin.id = null;
        checkin.save();
    }

}
