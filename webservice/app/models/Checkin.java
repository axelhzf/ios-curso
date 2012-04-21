package models;

import play.db.jpa.Model;

import javax.persistence.Entity;
import java.util.Date;

/**
 * User: axelhzf
 */
@Entity
public class Checkin extends Model {
    public String nombre;
    public String categoria;
    public Double calificacion;
    public Double latitud;
    public Double longitud;
    public String usuario;
    public Date fechaCreacion;
}
