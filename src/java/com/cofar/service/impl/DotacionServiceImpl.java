/*
 * DotacionServiceImpl.java
 *
 * Created on 10 de enero de 2011, 09:49 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.service.impl;

import com.cofar.bean.util.Personal;
import com.cofar.bean.util.dotacion.Dotacion;
import com.cofar.bean.util.dotacion.DotacionAmortizacion;
import com.cofar.bean.util.dotacion.DotacionAsignada;
import com.cofar.bean.util.dotacion.DotacionDetalle;
import com.cofar.bean.util.dotacion.DotacionFinalizacion;
import com.cofar.bean.util.dotacion.DotacionGrupo;
import com.cofar.bean.util.dotacion.PersonalAsignacion;
import com.cofar.bean.util.dotacion.PersonalDotacion;
import com.cofar.service.DotacionService;
import com.cofar.util.TimeFunction;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.faces.model.SelectItem;
import org.joda.time.DateTime;

/**
 *
 * @author Ismael Juchazara
 */
public class DotacionServiceImpl extends BaseService implements DotacionService {
    
    /** Creates a new instance of DotacionServiceImpl */
    public DotacionServiceImpl() {
        super();
    }
    
    public boolean cancelarPagosDotacionPersonal(int personal, int prestamo, String descripcion){
        try{
            String query = "SELECT A.COD_GESTION_AMORTIZACION, A.COD_MES_AMORTIZACION, A.PORCENTAJE_AMORTIZACION, A.MONTO_AMORTIZACION FROM PRESTAMOS_DETALLE_AMORTIZACION A INNER JOIN MESES M ON(A.COD_MES_AMORTIZACION=M.COD_MES) WHERE A.COD_PERSONAL=" + personal + " AND A.COD_TIPO_PRESTAMO=" + prestamo + " ORDER BY A.COD_GESTION_AMORTIZACION, M.ORDEN_MES";
            ResultSet rs = this.ejecutaConsulta(query);
            double monto = 0;
            double porcentaje = 0;
            while(rs.next()){
                query = "SELECT COD_GESTION, COD_MES, MONTO_PRESTAMO_PLANILLA FROM PRESTAMOS_PLANILLA WHERE COD_PERSONAL=" + personal + " AND COD_TIPO_PRESTAMO=" + prestamo + " AND COD_GESTION=" + rs.getInt("COD_GESTION_AMORTIZACION") + " AND COD_MES=" + rs.getInt("COD_MES_AMORTIZACION");
                ResultSet rs2 = this.ejecutaConsulta(query);
                if(!rs2.next()){
                    monto += rs.getDouble("MONTO_AMORTIZACION");
                    porcentaje += Double.valueOf(rs.getString("PORCENTAJE_AMORTIZACION"));
                    String consulta_borrado = "DELETE FROM PRESTAMOS_DETALLE_AMORTIZACION WHERE COD_GESTION_AMORTIZACION=" + rs.getInt("COD_GESTION_AMORTIZACION") + " AND COD_MES_AMORTIZACION=" + rs.getInt("COD_MES_AMORTIZACION") + " AND COD_PERSONAL=" + personal + " AND COD_TIPO_PRESTAMO=" + prestamo;
                    this.ejecutaActualizacion(consulta_borrado);
                }
            }
            String borrar_finalizacion = "DELETE FROM PRESTAMOS_DETALLE_FINALIZACION WHERE COD_PERSONAL=" + personal +" AND COD_TIPO_PRESTAMO=" + prestamo;
            this.ejecutaActualizacion(borrar_finalizacion);
            String consulta_agregado = "INSERT INTO PRESTAMOS_DETALLE_FINALIZACION VALUES(" + prestamo + ", " + personal + ", " + monto + ", " + porcentaje + ", '" + TimeFunction.formatearFecha(new Date()) + "', '" + descripcion + "')";
            this.ejecutaActualizacion(consulta_agregado);
            return true;
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean finalizarDotacionPersonal(int personal, int prestamo, String descripcion){
        try{
            String query = "SELECT A.COD_GESTION_AMORTIZACION, A.COD_MES_AMORTIZACION, A.PORCENTAJE_AMORTIZACION, A.MONTO_AMORTIZACION FROM PRESTAMOS_DETALLE_AMORTIZACION A INNER JOIN MESES M ON(A.COD_MES_AMORTIZACION=M.COD_MES) WHERE A.COD_PERSONAL=" + personal + " AND A.COD_TIPO_PRESTAMO=" + prestamo + " ORDER BY A.COD_GESTION_AMORTIZACION, M.ORDEN_MES";
            ResultSet rs = this.ejecutaConsulta(query);
            boolean encontrado = false;
            double monto = 0;
            double porcentaje = 0;
            int gestion = 0;
            int mes = 0;
            while(rs.next()){
                query = "SELECT COD_GESTION, COD_MES, MONTO_PRESTAMO_PLANILLA FROM PRESTAMOS_PLANILLA WHERE COD_PERSONAL=" + personal + " AND COD_TIPO_PRESTAMO=" + prestamo + " AND COD_GESTION=" + rs.getInt("COD_GESTION_AMORTIZACION") + " AND COD_MES=" + rs.getInt("COD_MES_AMORTIZACION");
                ResultSet rs2 = this.ejecutaConsulta(query);
                if(!rs2.next()){
                    monto += rs.getDouble("MONTO_AMORTIZACION");
                    porcentaje += Double.valueOf(rs.getString("PORCENTAJE_AMORTIZACION"));
                    if(!encontrado){
                        gestion = rs.getInt("COD_GESTION_AMORTIZACION");
                        mes = rs.getInt("COD_MES_AMORTIZACION");
                        encontrado = true;
                    }
                    String consulta_borrado = "DELETE FROM PRESTAMOS_DETALLE_AMORTIZACION WHERE COD_GESTION_AMORTIZACION=" + rs.getInt("COD_GESTION_AMORTIZACION") + " AND COD_MES_AMORTIZACION=" + rs.getInt("COD_MES_AMORTIZACION") + " AND COD_PERSONAL=" + personal + " AND COD_TIPO_PRESTAMO=" + prestamo;
                    this.ejecutaActualizacion(consulta_borrado);
                }
            }
            String consulta_agregado = "INSERT INTO PRESTAMOS_DETALLE_AMORTIZACION VALUES(" + prestamo + ", " + personal + ", " + gestion + ", " + mes + ", '" + porcentaje + "', " + monto + ")";
            this.ejecutaActualizacion(consulta_agregado);
            String borrar_finalizacion = "DELETE FROM PRESTAMOS_DETALLE_FINALIZACION WHERE COD_PERSONAL=" + personal +" AND COD_TIPO_PRESTAMO=" + prestamo;
            this.ejecutaActualizacion(borrar_finalizacion);
            String consulta_descripcion = "INSERT INTO PRESTAMOS_DETALLE_FINALIZACION VALUES(" + prestamo + ", " + personal + ", " + monto + ", " + porcentaje + ", '" + TimeFunction.formatearFecha(new Date()) + "', '" + descripcion + "')";
            this.ejecutaActualizacion(consulta_descripcion);
            return true;
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Dotacion> listaDotaciones(){
        try {
            List<Dotacion> resultList = new ArrayList();
            String query = "SELECT DISTINCT(D.NOMBRE_DOTACION), D.COD_DOTACION, G.COD_GESTION, ";
            query += " G.NOMBRE_GESTION FROM DOTACIONES D INNER JOIN TIPOS_PRESTAMO T ";
            query += "ON(D.COD_DOTACION=T.COD_DOTACION) INNER JOIN GESTIONES G ON(T.COD_GESTION=G.COD_GESTION) ";
            query += "WHERE D.COD_ESTADO_REGISTRO=1 ORDER BY G.NOMBRE_GESTION";
            ResultSet rs = this.ejecutaConsulta(query);
            while(rs.next()){
                resultList.add(new Dotacion(rs.getInt("COD_DOTACION"), rs.getString("NOMBRE_DOTACION"), rs.getInt("COD_GESTION"), rs.getString("NOMBRE_GESTION")));
            }
            return resultList;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public PersonalAsignacion listaDotacionesPersonal(int codigo){
        try{
            String query = "SELECT D.NOMBRE_DOTACION, T.COD_TIPO_PRESTAMO, T.CANTIDAD_PRESTAMO, T.NUMERO_MESES_AMORTIZACION, G.NOMBRE_GESTION, M.NOMBRE_MES FROM DOTACIONES D ";
            query += "INNER JOIN TIPOS_PRESTAMO T ON(D.COD_DOTACION=T.COD_DOTACION) INNER JOIN PRESTAMOS_DETALLE P ON(T.COD_TIPO_PRESTAMO=P.COD_TIPO_PRESTAMO) INNER JOIN GESTIONES G ON(P.COD_GESTION=G.COD_GESTION) INNER JOIN MESES M ON(P.COD_MES=M.COD_MES) WHERE P.COD_PERSONAL=" + codigo + " ORDER BY P.COD_GESTION, P.COD_MES";
            ResultSet rs_lp = this.ejecutaConsulta(query);
            Personal p = this.buscarPersonal(codigo);
            List<DotacionAsignada> dotaciones = new ArrayList();
            while(rs_lp.next()){
                String datos_prestamo = "SELECT COUNT(T.COD_PERSONAL) AS CUOTAS, ROUND(SUM(MONTO_PRESTAMO_PLANILLA),2) AS MONTO_PAGADO ";
                datos_prestamo += "FROM PRESTAMOS_PLANILLA T WHERE T.COD_TIPO_PRESTAMO = " + rs_lp.getInt("COD_TIPO_PRESTAMO")+ " AND T.COD_PERSONAL=" + codigo + " GROUP BY T.COD_PERSONAL";
                ResultSet rs_dp = this.ejecutaConsulta(datos_prestamo);
                double pagado = 0;
                int cuotas = 0;
                if(rs_dp.next()){
                    pagado = rs_dp.getDouble("MONTO_PAGADO");
                    cuotas = rs_dp.getInt("CUOTAS");
                }
                String consulta_meses = "SELECT COUNT(COD_TIPO_PRESTAMO) AS NUMERO_MESES FROM PRESTAMOS_DETALLE_AMORTIZACION WHERE COD_TIPO_PRESTAMO=" + rs_lp.getInt("COD_TIPO_PRESTAMO") + " AND COD_PERSONAL=" + codigo;
                int cantidad_meses = 0;
                ResultSet rstemp = this.ejecutaConsulta(consulta_meses);
                if(rstemp.next()){
                    cantidad_meses = rstemp.getInt("NUMERO_MESES");
                }else{
                    cantidad_meses = rs_lp.getInt("NUMERO_MESES_AMORTIZACION");
                }
                /*AGREGADO PARA MOSTRAR LAS MODIFICACIONES HECHAS A LA DOTACION */
                String dotacion_finalizacion = "SELECT F.MONTO_AMORTIZACION, F.PORCENTAJE_AMORTIZACION, F.FECHA_FINALIZACION, F.DESCRIPCION FROM PRESTAMOS_DETALLE_FINALIZACION F WHERE F.COD_PERSONAL=" + codigo + " AND F.COD_TIPO_PRESTAMO=" + rs_lp.getInt("COD_TIPO_PRESTAMO");
                DotacionFinalizacion dotfin = null;
                ResultSet rs_dotfin = this.ejecutaConsulta(dotacion_finalizacion);
                if(rs_dotfin.next()){
                    dotfin = new DotacionFinalizacion(rs_dotfin.getDouble("MONTO_AMORTIZACION"), Double.valueOf(rs_dotfin.getString("PORCENTAJE_AMORTIZACION")), rs_dotfin.getDate("FECHA_FINALIZACION"), rs_dotfin.getString("DESCRIPCION"));
                }
                dotaciones.add(new DotacionAsignada(rs_lp.getInt("COD_TIPO_PRESTAMO"), codigo, rs_lp.getString("NOMBRE_DOTACION"), rs_lp.getDouble("CANTIDAD_PRESTAMO"), rs_lp.getString("NOMBRE_GESTION"), rs_lp.getString("NOMBRE_MES"), pagado, cantidad_meses, cuotas, dotfin));
            }
            return (new PersonalAsignacion(p.getCodigo(), p.getNombreCompleto(), p.getCargo(), p.getNombreArea(), (dotaciones.size()>0? dotaciones: null)));
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }
    
    public List<DotacionAmortizacion> listaAmortizacionDotacionEmpleado(int personal, int prestamo){
        try{
            String query = "SELECT G.COD_GESTION, M.COD_MES, G.COD_GESTION, G.NOMBRE_GESTION, M.NOMBRE_MES, P.PORCENTAJE_AMORTIZACION, P.MONTO_AMORTIZACION FROM PRESTAMOS_DETALLE_AMORTIZACION P INNER JOIN GESTIONES G ON(G.COD_GESTION=P.COD_GESTION_AMORTIZACION) INNER JOIN MESES M ON(P.COD_MES_AMORTIZACION=M.COD_MES) WHERE COD_PERSONAL=" + personal + " AND P.COD_TIPO_PRESTAMO=" + prestamo + " ORDER BY P.COD_GESTION_AMORTIZACION, M.ORDEN_MES";
            ResultSet rs = this.ejecutaConsulta(query);
            List<DotacionAmortizacion> amortizaciones = new ArrayList();
            while(rs.next()){
                query = "SELECT COD_GESTION, COD_MES, MONTO_PRESTAMO_PLANILLA FROM PRESTAMOS_PLANILLA WHERE COD_PERSONAL=" + personal + " AND COD_TIPO_PRESTAMO=" + prestamo + " AND COD_GESTION=" + rs.getInt("COD_GESTION") + " AND COD_MES=" + rs.getInt("COD_MES");
                ResultSet rs2 = this.ejecutaConsulta(query);
                //amortizaciones.add(new DotacionAmortizacion(rs.getString("NOMBRE_GESTION"), rs.getString("NOMBRE_MES"), Double.valueOf(rs.getString("PORCENTAJE_AMORTIZACION")), rs.getDouble("MONTO_AMORTIZACION"), rs2.next()));
                amortizaciones.add(new DotacionAmortizacion(personal, rs.getInt("COD_GESTION"), rs.getInt("COD_MES"), prestamo, rs.getString("NOMBRE_GESTION"), rs.getString("NOMBRE_MES"), Double.valueOf(rs.getString("PORCENTAJE_AMORTIZACION")), rs.getDouble("MONTO_AMORTIZACION"), rs2.next()));
                //public DotacionAmortizacion(int personal, int codigoGestion, int codigoMes, int codigoPrestamo, String gestion, String mes, double porcentaje, double monto, boolean pagado) {
            }
            return(amortizaciones.size()>0? amortizaciones : null);
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }
    
    public List<DotacionDetalle> ListaEmpleadosDotacionGrupo(List<Dotacion> dotaciones, int tipoPersonal, int tipoSaldo){
        try{
            List<DotacionDetalle> dotacionesDetalle = new ArrayList();
            if(dotaciones!=null){
                for(Dotacion dotacion : dotaciones){
                    if(dotacion.isSeleccion()){
                        List<PersonalDotacion> empleados = new ArrayList();
                        int codigo = Integer.valueOf(dotacion.getCodigo());
                        DotacionDetalle dotacionDetalle = this.buscarDotacionDetalle(codigo);
                        String lista_empleados = "SELECT T.COD_PERSONAL, COD_TIPO_PRESTAMO FROM PRESTAMOS_DETALLE T INNER JOIN PERSONAL P ON(P.COD_PERSONAL=T.COD_PERSONAL) WHERE T.COD_TIPO_PRESTAMO IN (SELECT COD_TIPO_PRESTAMO FROM TIPOS_PRESTAMO WHERE COD_DOTACION=" + codigo + " AND COD_GESTION="  + dotacion.getGestion() + ") ORDER BY P.AP_PATERNO_PERSONAL";
                        ResultSet rs_le = this.ejecutaConsulta(lista_empleados);
                        while(rs_le.next()){
                            Personal p = this.buscarPersonal(rs_le.getInt("COD_PERSONAL"));
                            String datos_prestamo = "SELECT COUNT(T.COD_PERSONAL) AS CUOTAS, ROUND(SUM(MONTO_PRESTAMO_PLANILLA),2) AS MONTO_PAGADO ";
                            datos_prestamo += "FROM PRESTAMOS_PLANILLA T WHERE T.COD_TIPO_PRESTAMO = " + rs_le.getInt("COD_TIPO_PRESTAMO")+ " AND T.COD_PERSONAL=" + rs_le.getInt("COD_PERSONAL") + " GROUP BY T.COD_PERSONAL";
                            ResultSet rs_dp = this.ejecutaConsulta(datos_prestamo);
                            int cuotas = 0;
                            double monto_pagado = 0;
                            if(rs_dp.next()){
                                cuotas = rs_dp.getInt("CUOTAS");
                                monto_pagado = rs_dp.getDouble("MONTO_PAGADO");
                            }
                            DateTime finContrato = this.fechaConclusionContrato(p.getCodigo());
                            boolean retirado = false;
                            if(finContrato!=null){
                                String query = "SELECT COD_ESTADO_PERSONA FROM PERSONAL WHERE COD_PERSONAL=" + rs_le.getInt("COD_PERSONAL");
                                ResultSet rs = this.ejecutaConsulta(query);
                                int activo = 1;
                                if(rs.next()){
                                    activo = rs.getInt("COD_ESTADO_PERSONA");
                                }
                                retirado = (finContrato.isBefore(new DateTime(new Date()))) && (activo==2);
                            }
                            switch(tipoPersonal){
                                case 2:
                                    if(!retirado){
                                        DotacionGrupo dg = this.buscarDotacionGrupo(rs_le.getInt("COD_TIPO_PRESTAMO"));
                                        if(dg!=null){
                                            PersonalDotacion personalActivo = new PersonalDotacion(dg.getGestion(), dg.getInicio(), dg.getMeses(), p.getCodigo(), p.getNombreCompleto(), p.getCargo(), p.getNombreArea(), monto_pagado, dg.getPrestamo(), cuotas, retirado);
                                            switch(tipoSaldo){
                                                case 2:
                                                    if(personalActivo.getRestante()>0){
                                                        empleados.add(personalActivo);
                                                    }
                                                    break;
                                                case 3:
                                                    if(personalActivo.getRestante()== 0){
                                                        empleados.add(personalActivo);
                                                    }
                                                    break;
                                                default:
                                                    empleados.add(personalActivo);
                                            }
                                        }
                                    }
                                    break;
                                case 3:
                                    if(retirado){
                                        DotacionGrupo dg = this.buscarDotacionGrupo(rs_le.getInt("COD_TIPO_PRESTAMO"));
                                        if(dg!=null){
                                            PersonalDotacion personalActivo = new PersonalDotacion(dg.getGestion(), dg.getInicio(), dg.getMeses(), p.getCodigo(), p.getNombreCompleto(), p.getCargo(), p.getNombreArea(), monto_pagado, dg.getPrestamo(), cuotas, retirado);
                                            switch(tipoSaldo){
                                                case 2:
                                                    if(personalActivo.getRestante()>0){
                                                        empleados.add(personalActivo);
                                                    }
                                                    break;
                                                case 3:
                                                    if(personalActivo.getRestante()== 0){
                                                        empleados.add(personalActivo);
                                                    }
                                                    break;
                                                default:
                                                    empleados.add(personalActivo);
                                            }
                                        }
                                    }
                                    break;
                                default:
                                    DotacionGrupo dg = this.buscarDotacionGrupo(rs_le.getInt("COD_TIPO_PRESTAMO"));
                                    if(dg!=null){
                                        PersonalDotacion personal = new PersonalDotacion(dg.getGestion(), dg.getInicio(), dg.getMeses(), p.getCodigo(), p.getNombreCompleto(), p.getCargo(), p.getNombreArea(), monto_pagado, dg.getPrestamo(), cuotas, retirado);
                                        switch(tipoSaldo){
                                            case 2:
                                                if(personal.getRestante()>0){
                                                    empleados.add(personal);
                                                }
                                                break;
                                            case 3:
                                                if(personal.getRestante()== 0){
                                                    empleados.add(personal);
                                                }
                                                break;
                                            default:
                                                empleados.add(personal);
                                        }
                                    }
                            }
                        }
                        if(empleados.size()>0){
                            dotacionDetalle.setEmpleados(empleados);
                        }
                        if(empleados.size()>0){
                            dotacionesDetalle.add(dotacionDetalle);
                        }
                    }
                }
                return (dotacionesDetalle.size()>0? dotacionesDetalle: null);
            }else{
                return null;
            }
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }
    
    public List<DotacionDetalle> ListaEmpleadosDotacion(List dotaciones, int tipoPersonal, int tipoSaldo) {
        try{
            List<DotacionDetalle> dotacionesDetalle = new ArrayList();
            for(int i = 0; i<dotaciones.size(); i++){
                List<PersonalDotacion> empleados = new ArrayList();
                int codigo = Integer.valueOf(dotaciones.get(i).toString());
                DotacionDetalle dotacionDetalle = this.buscarDotacionDetalle(codigo);
                String lista_empleados = "SELECT T.COD_PERSONAL, COD_TIPO_PRESTAMO FROM PRESTAMOS_DETALLE T INNER JOIN PERSONAL P ON(P.COD_PERSONAL=T.COD_PERSONAL) WHERE T.COD_TIPO_PRESTAMO IN (SELECT COD_TIPO_PRESTAMO FROM TIPOS_PRESTAMO WHERE COD_DOTACION=" + codigo + ") ORDER BY P.AP_PATERNO_PERSONAL";
                ResultSet rs_le = this.ejecutaConsulta(lista_empleados);
                while(rs_le.next()){
                    Personal p = this.buscarPersonal(rs_le.getInt("COD_PERSONAL"));
                    String datos_prestamo = "SELECT COUNT(T.COD_PERSONAL) AS CUOTAS, ROUND(SUM(MONTO_PRESTAMO_PLANILLA),2) AS MONTO_PAGADO ";
                    datos_prestamo += "FROM PRESTAMOS_PLANILLA T WHERE T.COD_TIPO_PRESTAMO = " + rs_le.getInt("COD_TIPO_PRESTAMO")+ " AND T.COD_PERSONAL=" + rs_le.getInt("COD_PERSONAL") + " GROUP BY T.COD_PERSONAL";
                    ResultSet rs_dp = this.ejecutaConsulta(datos_prestamo);
                    int cuotas = 0;
                    double monto_pagado = 0;
                    if(rs_dp.next()){
                        cuotas = rs_dp.getInt("CUOTAS");
                        monto_pagado = rs_dp.getDouble("MONTO_PAGADO");
                    }
                    DateTime finContrato = this.fechaConclusionContrato(p.getCodigo());
                    boolean retirado = false;
                    if(finContrato!=null){
                        String query = "SELECT COD_ESTADO_PERSONA FROM PERSONAL WHERE COD_PERSONAL=" + rs_le.getInt("COD_PERSONAL");
                        ResultSet rs = this.ejecutaConsulta(query);
                        int activo = 1;
                        if(rs.next()){
                            activo = rs.getInt("COD_ESTADO_PERSONA");
                        }
                        retirado = (finContrato.isBefore(new DateTime(new Date()))) && (activo==2);
                    }
                    switch(tipoPersonal){
                        case 2:
                            if(!retirado){
                                DotacionGrupo dg = this.buscarDotacionGrupo(rs_le.getInt("COD_TIPO_PRESTAMO"));
                                if(dg!=null){
                                    PersonalDotacion personalActivo = new PersonalDotacion(dg.getGestion(), dg.getInicio(), dg.getMeses(), p.getCodigo(), p.getNombreCompleto(), p.getCargo(), p.getNombreArea(), monto_pagado, dg.getPrestamo(), cuotas, retirado);
                                    switch(tipoSaldo){
                                        case 2:
                                            if(personalActivo.getRestante()>0){
                                                empleados.add(personalActivo);
                                            }
                                            break;
                                        case 3:
                                            if(personalActivo.getRestante()== 0){
                                                empleados.add(personalActivo);
                                            }
                                            break;
                                        default:
                                            empleados.add(personalActivo);
                                    }
                                }
                            }
                            break;
                        case 3:
                            if(retirado){
                                DotacionGrupo dg = this.buscarDotacionGrupo(rs_le.getInt("COD_TIPO_PRESTAMO"));
                                if(dg!=null){
                                    PersonalDotacion personalActivo = new PersonalDotacion(dg.getGestion(), dg.getInicio(), dg.getMeses(), p.getCodigo(), p.getNombreCompleto(), p.getCargo(), p.getNombreArea(), monto_pagado, dg.getPrestamo(), cuotas, retirado);
                                    switch(tipoSaldo){
                                        case 2:
                                            if(personalActivo.getRestante()>0){
                                                empleados.add(personalActivo);
                                            }
                                            break;
                                        case 3:
                                            if(personalActivo.getRestante()== 0){
                                                empleados.add(personalActivo);
                                            }
                                            break;
                                        default:
                                            empleados.add(personalActivo);
                                    }
                                }
                            }
                            break;
                        default:
                            DotacionGrupo dg = this.buscarDotacionGrupo(rs_le.getInt("COD_TIPO_PRESTAMO"));
                            if(dg!=null){
                                PersonalDotacion personal = new PersonalDotacion(dg.getGestion(), dg.getInicio(), dg.getMeses(), p.getCodigo(), p.getNombreCompleto(), p.getCargo(), p.getNombreArea(), monto_pagado, dg.getPrestamo(), cuotas, retirado);
                                switch(tipoSaldo){
                                    case 2:
                                        if(personal.getRestante()>0){
                                            empleados.add(personal);
                                        }
                                        break;
                                    case 3:
                                        if(personal.getRestante()== 0){
                                            empleados.add(personal);
                                        }
                                        break;
                                    default:
                                        empleados.add(personal);
                                }
                            }
                    }
                }
                if(empleados.size()>0){
                    dotacionDetalle.setEmpleados(empleados);
                }
                if(empleados.size()>0){
                    dotacionesDetalle.add(dotacionDetalle);
                }
            }
            return (dotacionesDetalle.size()>0? dotacionesDetalle: null);
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }
    
    public List listaEmpleadosDotacion(int dotacion, int gestion){
        return null;
    }
    
    public Personal buscarPersonal(int codigo) {
        try{
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + P.NOMBRES_PERSONAL AS NOMBRE_COMPLETO, ";
            query += " C.DESCRIPCION_CARGO, AE.NOMBRE_AREA_EMPRESA FROM PERSONAL P INNER JOIN CARGOS C ON (P.CODIGO_CARGO=C.CODIGO_CARGO) ";
            query += "INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) WHERE P.COD_PERSONAL=" + codigo;
            ResultSet resultSet = ejecutaConsulta(query);
            if(resultSet.next()){
                return (new Personal(resultSet.getInt("COD_PERSONAL"), resultSet.getString("NOMBRE_COMPLETO"), resultSet.getString("DESCRIPCION_CARGO"), 0, resultSet.getString("NOMBRE_AREA_EMPRESA"), 0, 0, false, false));
            }else{
                return null;
            }
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }
    
    public DotacionDetalle buscarDotacionDetalle(int codigo){
        try{
            String query = "SELECT COD_DOTACION, NOMBRE_DOTACION FROM DOTACIONES WHERE COD_ESTADO_REGISTRO=1 AND COD_DOTACION=" + codigo;
            ResultSet rs = this.ejecutaConsulta(query);
            if(rs.next()){
                return (new DotacionDetalle(rs.getInt("COD_DOTACION"), rs.getString("NOMBRE_DOTACION")));
            }else{
                return null;
            }
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }
    
    public DotacionGrupo buscarDotacionGrupo(int codigo){
        try{
            String lista_subgrupos = "SELECT P.COD_TIPO_PRESTAMO, P.CANTIDAD_PRESTAMO, P.NUMERO_MESES_AMORTIZACION, G.NOMBRE_GESTION, M.NOMBRE_MES, P.OBS_TIPO_PRESTAMO FROM TIPOS_PRESTAMO P INNER JOIN GESTIONES G ON(P.COD_GESTION=G.COD_GESTION) INNER JOIN MESES M ON(P.COD_MES=M.COD_MES) WHERE P.COD_TIPO_PRESTAMO=" + codigo + " AND P.COD_ESTADO_REGISTRO=1 ORDER BY P.CANTIDAD_PRESTAMO DESC" ;
            ResultSet rs_lg = this.ejecutaConsulta(lista_subgrupos);
            if(rs_lg.next()){
                return new DotacionGrupo(rs_lg.getInt("COD_TIPO_PRESTAMO"), rs_lg.getDouble("CANTIDAD_PRESTAMO"), rs_lg.getInt("NUMERO_MESES_AMORTIZACION"), rs_lg.getString("NOMBRE_MES"), rs_lg.getString("NOMBRE_GESTION"));
            }else{
                return null;
            }
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }
    
    public List<SelectItem> listaDotacionesGestion(int gestion){
        try{
            String query = "SELECT DISTINCT(D.COD_DOTACION), D.NOMBRE_DOTACION FROM DOTACIONES D INNER JOIN TIPOS_PRESTAMO T ON(T.COD_DOTACION=D.COD_DOTACION) WHERE T.COD_GESTION=" + gestion;
            ResultSet rs = this.ejecutaConsulta(query);
            List resultList = new ArrayList();
            while(rs.next()){
                resultList.add(new SelectItem(rs.getString("COD_DOTACION"), rs.getString("NOMBRE_DOTACION")));
            }
            return (resultList.size()>0? resultList : null);
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
    }
    
    
}
