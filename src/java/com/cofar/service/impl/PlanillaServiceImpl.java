/*
 * PlanillaServiceImpl.java
 *
 * Created on 19 de noviembre de 2010, 02:31 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.service.impl;

import com.cofar.bean.util.AsistenciaPlanilla;
import com.cofar.bean.util.PersonalPlanilla;
import com.cofar.service.PlanillaService;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.joda.time.DateTime;

/**
 *
 * @author Ismael Juchazara
 */
public class PlanillaServiceImpl extends BaseService implements PlanillaService {
    
    /** Creates a new instance of PlanillaServiceImpl */
    public PlanillaServiceImpl() {
        super();
    }
    
    public List listaTodoPersonalTrabajadoPeriodo(Date inicio, Date fin){
        try{
            SimpleDateFormat formateo=new SimpleDateFormat("MM/dd/yyyy");
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + P.NOMBRES_PERSONAL AS NOMBRE_COMPLETO ";
            query+= "FROM PERSONAL P WHERE P.COD_ESTADO_PERSONA<3 ORDER BY NOMBRE_COMPLETO";
            System.out.println(query);
            ResultSet rs = ejecutaConsulta(query);
            List resultList = new ArrayList();
            while(rs.next()){
                PersonalPlanilla personal = this.personalTrabajadoPeriodo(rs.getInt("COD_PERSONAL"), inicio, fin);
                if(personal!=null){
                    resultList.add(personal);
                }
            }
            return ((resultList.size()>0)? resultList: null);
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }
    
    public List listaPersonalTrabajadoPeriodo(int area, Date inicio, Date fin){
        try{
            List<PersonalPlanilla> resultList = new ArrayList();
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL FROM PERSONAL P INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) WHERE P.COD_ESTADO_PERSONA<3 AND P.COD_AREA_EMPRESA=" + area + " ORDER BY P.AP_PATERNO_PERSONAL";
            ResultSet rs = ejecutaConsulta(query);
            while(rs.next()){
                PersonalPlanilla personal = this.personalTrabajadoPeriodo(rs.getInt("COD_PERSONAL"), inicio, fin);
                if(personal!=null){
                    resultList.add(personal);
                }
            }
            return ((resultList.size()>0)? resultList: null);
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
        
    }
    
    public PersonalPlanilla personalTrabajadoPeriodo(int codigo, Date inicio, Date fin){
        try{
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + P.NOMBRES_PERSONAL AS NOMBRE_COMPLETO,";
            query += " C.DESCRIPCION_CARGO, P.SEXO_PERSONAL, AE.NOMBRE_AREA_EMPRESA FROM PERSONAL P INNER JOIN CARGOS C ON (P.CODIGO_CARGO=C.CODIGO_CARGO) ";
            query += "INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) WHERE P.COD_ESTADO_PERSONA<3 AND P.COD_PERSONAL=" + codigo + " ORDER BY P.AP_PATERNO_PERSONAL";
            ResultSet rs = ejecutaConsulta(query);
            PersonalPlanilla personal = null;
            if(rs.next()){
                List<AsistenciaPlanilla> listaAsistencia = this.listaAsistenciaFechas(codigo, inicio, fin, rs.getInt("SEXO_PERSONAL"));
                if(listaAsistencia!=null){
                    //personal = new PersonalPlanilla(rs.getInt("COD_PERSONAL"), rs.getString("NOMBRE_COMPLETO"), rs.getString("DESCRIPCION_CARGO"), rs.getString("NOMBRE_AREA_EMPRESA"), listaAsistencia);
                    personal = null;
                }
            }
            return (personal);
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }
    
    private List<AsistenciaPlanilla> listaAsistenciaFechas(int codigo, Date inicio, Date fin, int sexo){
        try{
            SimpleDateFormat formateo=new SimpleDateFormat("yyyy/MM/dd");
            String query = "SELECT FECHA_ASISTENCIA, HORA_INGRESO1, HORA_SALIDA1, HORA_INGRESO2, HORA_SALIDA2 FROM CONTROL_ASISTENCIA WHERE COD_PERSONAL=" + codigo + " AND FECHA_ASISTENCIA BETWEEN '" + formateo.format(inicio) + "' AND '" + formateo.format(fin) + "' ORDER BY FECHA_ASISTENCIA ASC";
            List<AsistenciaPlanilla> listaAsistencia = new ArrayList();
            ResultSet resultSet = ejecutaConsulta(query);
            while(resultSet.next()){
                DateTime ingreso1 = resultSet.getTimestamp("HORA_INGRESO1")!=null? new DateTime(resultSet.getTimestamp("HORA_INGRESO1")): null;
                DateTime salida1 = resultSet.getTimestamp("HORA_SALIDA1")!=null? new DateTime(resultSet.getTimestamp("HORA_SALIDA1")): null;
                DateTime ingreso2 = resultSet.getTimestamp("HORA_INGRESO2")!=null? new DateTime(resultSet.getTimestamp("HORA_INGRESO2")): null;
                DateTime salida2 = resultSet.getTimestamp("HORA_SALIDA2")!=null? new DateTime(resultSet.getTimestamp("HORA_SALIDA2")): null;
                if((ingreso1!=null)||(ingreso2!=null)){
                    DateTime fecha = new DateTime(resultSet.getDate("FECHA_ASISTENCIA").getTime());
                    //listaAsistencia.add(new AsistenciaPlanilla(fecha, ingreso1, salida1, ingreso2, salida2, sexo));
                }
            }
            return ((listaAsistencia.size()>0)? listaAsistencia: null);
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }
    
    private int minutosPersonalVacacion(int codigo, Date inicio, Date fin){
        float resultado = 0;
        try{
            DateTime fecha_inicio = new DateTime(inicio);
            DateTime fecha_fin = new DateTime(fin);
            
            //while(fecha_inicio.isBefore(fecha_fin)){
//                int tipoVacacion = this.comparaFechaVacacion(codigo, inicioIntervalo);
//                inicioIntervalo = inicioIntervalo.plusDays(1);
            // }
            
            
            SimpleDateFormat formateo=new SimpleDateFormat("yyyy/MM/dd");
            String igual_inicio = "SELECT DIAS_TOMADOS FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND FECHA_INICIO_VACACION>= '" + formateo.format(inicio) + "'";
            ResultSet rs = this.ejecutaConsulta(igual_inicio);
            while(rs.next()){
                resultado += rs.getFloat("DIAS_TOMADOS");
            }
            
            return (((int)(resultado)));
        }catch(Exception e){
            e.printStackTrace();
            return 0;
        }
    }
    
    private int comparaFechaVacacion(int codigo, DateTime fecha){
        int resultado = 0;
        try{
            SimpleDateFormat formateo=new SimpleDateFormat("yyyy/MM/dd");
            String igual_inicio = "SELECT COD_DIA_TOMADO, TIPO_VACACION_INICIO, TURNO_INICIO FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND FECHA_INICIO_VACACION= '" + formateo.format(fecha.toDate()) + "'";
            ResultSet rs_igual_inicio = this.ejecutaConsulta(igual_inicio);
            if(rs_igual_inicio.next()){
                if(rs_igual_inicio.getInt("TIPO_VACACION_INICIO")==1){
                    resultado = 3;
                }else{
                    if(rs_igual_inicio.getInt("TURNO_INICIO")==2){
                        resultado = 1;
                    }else{
                        resultado = 2;
                    }
                }
            }else {
                String igual_final = "SELECT COD_DIA_TOMADO, TIPO_VACACION_FINAL FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND FECHA_FINAL_VACACION= '" + formateo.format(fecha.toDate()) + "'";
                ResultSet rs_igual_final = this.ejecutaConsulta(igual_final);
                if(rs_igual_final.next()){
                    if(rs_igual_final.getInt("TIPO_VACACION_FINAL")==1){
                        resultado = 3;
                    }else {
                        resultado = 1;
                    }
                }else {
                    String entre_intervalo = "SELECT COD_DIA_TOMADO, TIPO_VACACION_FINAL FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND '" + formateo.format(fecha.toDate()) + "' BETWEEN FECHA_INICIO_VACACION AND FECHA_FINAL_VACACION";
                    ResultSet rs_entre_intervalo = this.ejecutaConsulta(entre_intervalo);
                    if(rs_entre_intervalo.next()){
                        resultado = 3;
                    }
                }
            }
            return resultado;
        }catch(Exception e){
            e.printStackTrace();
            return 0;
        }
    }
    
}
