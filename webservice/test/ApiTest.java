import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.junit.*;
import play.test.*;
import play.mvc.*;
import play.mvc.Http.*;
import models.*;

import java.lang.reflect.Type;
import java.util.List;

public class ApiTest extends FunctionalTest {

    public static Gson gson = new Gson();

    @Test
    public void testThatIndexPageWorks() {
        Checkin.deleteAll();

        assertCheckinListSize(0);

        Checkin checkin = new Checkin();
        checkin.nombre = "nombre";
        checkin.categoria = "bar";
        checkin.save();
        assertCheckinListSize(1);

        postCheckin(checkin);
        assertCheckinListSize(2);
    }

    private void postCheckin(Checkin checkin) {
        String checkinJson = gson.toJson(checkin);
        POST("/api/checkins", "application/json", checkinJson);
    }

    private void assertCheckinListSize(int expected){
        List<Checkin> checkins = getCheckinList();
        assertEquals(expected, checkins.size());
    }

    private List<Checkin> getCheckinList(){
        Response response = GET("/api/checkins");
        assertIsOk(response);
        String responseContent = getContent(response);

        Type checkinListType = new TypeToken<List<Checkin>>() {}.getType();
        List<Checkin> checkins = gson.fromJson(responseContent, checkinListType);
        return checkins;
    }

}