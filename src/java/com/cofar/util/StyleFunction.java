/*
 * StyleFunction.java
 *
 * Created on 25 de noviembre de 2010, 09:25 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.util;

import java.util.Date;
import org.joda.time.DateTime;

/**
 *
 * @author Ismael Juchazara
 */
public class StyleFunction {
    
    /** Creates a new instance of StyleFunction */
    public StyleFunction() {
    }
    
    public static String estiloRestante(boolean restante){
        if(restante){
            return "estilo_deuda";
        }else{
            return "estilo_diario";
        }
    }
    
    public static String estiloDia(Date fecha, int sexo, int division){
        DateTime temp_fecha = new DateTime(fecha);
        String resultado = "estilo_diario";
        switch(temp_fecha.getDayOfWeek()){
            case 6:
                if((sexo==2)||((division>0)&&(division<3))){
                    resultado = "estilo_sabado";
                }else{
                    resultado ="estilo_diario";
                }
                break;
            case 7:
                resultado = "estilo_domingo";
                break;
        }
        return resultado;
    }
    
    public static String estiloJustificacion(int tipo){
        String resultado = "";
        switch(tipo){
            case 1:
                resultado = "reemplazableColumn";
                break;
            case 2:
                resultado = "descuentoColumn";
                break;
            case 3:
                resultado = "siredeColumn";
                break;
            case 4:
                resultado = "reemplazableColumn";
                break;
            case 5:
                resultado = "feriadoColumn";
                break;
            case 6:
                resultado = "vacacionColumn";
                break;
            case 7:
                resultado = "sincontratoColumn";
                break;
        }
        return resultado;
    }
    
    public static String estiloProblema(int tipo){
        String resultado = "";
        switch(tipo){
            case 1:
                resultado = "excedenteMarcadoRow";
                break;
            case 2:
                resultado = "ningunMarcadoRow";
                break;
            case 3:
                resultado = "sinPrimerMarcadoRow";
                break;
            case 4:
                resultado = "sinSegundoMarcadoRow";
                break;
        }
        return resultado;
    }
}
