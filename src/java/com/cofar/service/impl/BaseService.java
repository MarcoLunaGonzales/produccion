/*
 * BaseServiceImpl.java
 *
 * Created on 19 de octubre de 2010, 09:18 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package com.cofar.service.impl;

import com.cofar.bean.util.Asistencia;
import com.cofar.bean.util.Justificacion;
import com.cofar.bean.util.MesGestion;
import com.cofar.bean.util.Permiso;
import com.cofar.bean.util.PermisoFecha;
import com.cofar.bean.util.PermisoHorario;
import com.cofar.bean.util.Personal;
import com.cofar.util.TimeFunction;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.model.SelectItem;
import org.joda.time.DateTime;

/**
 *
 * @author Ismael Juchazara
 */
public class BaseService {

    protected Connection connection;

    /** Creates a new instance of BaseServiceImpl */
    public BaseService() {
        try {
            this.connection = (Util.openConnection(connection));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ResultSet ejecutaConsulta(String query) {
        Statement statement = null;

        try {
            System.out.println("Entro base service ejecuta consulta:" + query);
            statement = this.connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            return (statement.executeQuery(query));


        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    protected int ejecutaActualizacion(String query) {
        Statement statement = null;
        try {
            statement = this.connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            return (statement.executeUpdate(query));

        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            try {
                statement.close();
            } catch (SQLException ex) {
                Logger.getLogger(BaseService.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    protected DateTime fechaInicioContrato(int codigo) {
        try {
            String query = "SELECT FECHA_INGRESO FROM CONTRATOS_PERSONAL WHERE NUMERO_CONTRATO = (SELECT MAX(NUMERO_CONTRATO) FROM CONTRATOS_PERSONAL WHERE COD_PERSONAL=" + codigo + ") AND COD_PERSONAL=" + codigo;
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);

            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                DateTime t = new DateTime(rs.getDate("FECHA_INGRESO"));
                st.close();
                st = null;
                rs.close();
                rs = null;
                return t;
            } else {
                st.close();
                st = null;
                rs.close();
                rs = null;
                return null;
            }

        } catch (Exception e) {
            return null;
        }
    }

    protected DateTime fechaConclusionContrato(int codigo) {
        try {
            String query = "SELECT FECHA_SALIDA FROM CONTRATOS_PERSONAL WHERE NUMERO_CONTRATO = (SELECT MAX(NUMERO_CONTRATO) FROM CONTRATOS_PERSONAL WHERE COD_PERSONAL=" + codigo + ") AND COD_PERSONAL=" + codigo;
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);

            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                if (rs.getDate("FECHA_SALIDA") != null) {
                    DateTime conclusion = new DateTime(rs.getDate("FECHA_SALIDA"));
                    if ((conclusion == null) || (conclusion.isEqual(new DateTime(TimeFunction.convertirCadenaDate("1900/01/01"))))) {
                        st.close();
                        st = null;
                        rs.close();
                        rs = null;
                        return (new DateTime(new Date()).plusYears(50));
                    } else {
                        st.close();
                        st = null;
                        rs.close();
                        rs = null;
                        return conclusion;
                    }
                } else {
                    st.close();
                    st = null;
                    rs.close();
                    rs = null;
                    return (new DateTime(new Date()).plusYears(50));
                }
            } else {
                st.close();
                st = null;
                rs.close();
                rs = null;
                return (new DateTime(new Date()).plusYears(50));
            }
        } catch (Exception e) {
            return null;
        }
    }

    public boolean isDiaLaboral(Date fecha, int division, int sexo, int codigo) {
        ResultSet rs = null;
        Statement st = null;
        try {
            if (fecha != null) {
                DateTime dia = new DateTime(fecha);
                if ((sexo == 2 || division < 3) && dia.getDayOfWeek() > 6) {
                    return false;
                } else {
                    String query = "SELECT NOMBRE_FERIADO FROM FERIADOS WHERE FERIADO_NAL_SI_NO=1 AND FECHA_FERIADO='" + TimeFunction.formatearFecha(fecha) + "'";
                    st = this.connection.createStatement();
                    rs = st.executeQuery(query);
                    //rs = this.ejecutaConsulta(query);
                    if (!rs.next()) {
                        if (division < 3) {
                            /*aumentado por regionales*/
                            String query2 = "SELECT P.COD_PERSONAL, P.COD_AREA_EMPRESA FROM PERSONAL P WHERE P.COD_PERSONAL=" + codigo + " AND P.COD_AREA_EMPRESA IN (SELECT COD_AREA_EMPRESA FROM AREAS_EMPRESA WHERE NOMBRE_AREA_EMPRESA LIKE '%AGENCIA%')";
                            ResultSet rs2 = this.ejecutaConsulta(query2);
                            if (rs2.next()) {
                                if (dia.getDayOfWeek() < 7) {
                                    st.close();
                                    st = null;
                                    rs.close();
                                    rs = null;
                                    return true;
                                } else {
                                    st.close();
                                    st = null;
                                    rs.close();
                                    rs = null;
                                    return false;
                                }
                            } else {
                                if (dia.getDayOfWeek() < 6) {
                                    st.close();
                                    st = null;
                                    rs.close();
                                    rs = null;
                                    return true;
                                } else {
                                    st.close();
                                    st = null;
                                    rs.close();
                                    rs = null;
                                    return false;
                                }
                            }
                        } else {
                            if (sexo == 1) {
                                if (dia.getDayOfWeek() < 7) {
                                    st.close();
                                    st = null;
                                    rs.close();
                                    rs = null;
                                    return true;
                                } else {
                                    st.close();
                                    st = null;
                                    rs.close();
                                    rs = null;
                                    return false;
                                }
                            } else {
                                if (dia.getDayOfWeek() < 6) {
                                    st.close();
                                    st = null;
                                    rs.close();
                                    rs = null;
                                    return true;
                                } else {
                                    st.close();
                                    st = null;
                                    rs.close();
                                    rs = null;
                                    return false;
                                }
                            }
                        }
                    } else {
                        st.close();
                        st = null;
                        rs.close();
                        rs = null;
                        return false;
                    }
                }
            } else {
                st.close();
                st = null;
                rs.close();
                rs = null;
                return false;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    protected Justificacion buscaPrimeraJustificacion(int codigo, int division, int sexo, Date fecha) {
        Justificacion j = this.buscaPrimerPermiso(codigo, division, sexo, fecha);
        if (j != null) {
            return j;
        } else {
            j = this.buscaPrimerFeriado(codigo, division, sexo, fecha);
            if (j != null) {
                return j;
            } else {
                j = this.buscaPrimerVacacion(codigo, division, sexo, fecha);
                if (j != null) {
                    return j;
                } else {
                    j = this.buscaPrimerPermisoFecha(codigo, division, sexo, fecha);
                    return j;
                }
            }
        }
    }

    protected Justificacion buscaSegundaJustificacion(int codigo, int division, int sexo, Date fecha) {
        Justificacion j = this.buscaSegundoPermiso(codigo, division, sexo, fecha);
        if (j != null) {
            return j;
        } else {
            j = this.buscaSegundoFeriado(codigo, division, sexo, fecha);
            if (j != null) {
                return j;
            } else {
                j = this.buscaSegundoVacacion(codigo, division, sexo, fecha);
                if (j != null) {
                    return j;
                } else {
                    j = this.buscaSegundoPermisoFecha(codigo, division, sexo, fecha);
                    return j;
                }
            }
        }
    }

    protected Justificacion buscaPrimerFeriado(int codigo, int division, int sexo, Date fecha) {
        try {
            String query = "SELECT NOMBRE_FERIADO FROM FERIADOS WHERE FERIADO_NAL_SI_NO=1 AND FECHA_FERIADO='" + TimeFunction.formatearFecha(fecha) + "'";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                st.close();
                st = null;
                rs.close();
                rs = null;
                return (new Justificacion("FERIADO", "FERIADO", 5, TimeFunction.minutosTurno(1, division, sexo, codigo)));
            } else {
                rs.close();
                rs = null;
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    protected Justificacion buscaSegundoFeriado(int codigo, int division, int sexo, Date fecha) {
        try {
            String query = "SELECT NOMBRE_FERIADO FROM FERIADOS WHERE FERIADO_NAL_SI_NO=1 AND FECHA_FERIADO='" + TimeFunction.formatearFecha(fecha) + "'";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                Justificacion p = (new Justificacion("FERIADO", "FERIADO", 5, TimeFunction.minutosTurno(2, division, sexo, codigo)));
                rs.close();
                st.close();
                rs = null;
                st = null;
                return (p);
            } else {
                rs.close();
                st.close();
                rs = null;
                st = null;
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    protected Justificacion buscaPrimerPermiso(int codigo, int division, int sexo, Date fecha) {
        try {
            String query = "SELECT P.TURNO_PERMISO, P.MODALIDAD, T.NOMBRE_TIPO_PERMISO FROM PERSONAL_PERMISOS_TURNO P INNER JOIN TIPOS_PERMISO T ON (P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE COD_PERSONAL=" + codigo + " AND ((TURNO_PERMISO=1) OR (TURNO_PERMISO=3)) AND FECHA_PERMISO='" + TimeFunction.formatearFecha(fecha) + "'";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                Justificacion p = (new Justificacion("PERMISO", rs.getString("NOMBRE_TIPO_PERMISO"), rs.getInt("MODALIDAD"), TimeFunction.minutosTurno(1, division, sexo, codigo)));
                rs.close();
                st.close();
                rs = null;
                st = null;
                return p;
            } else {
                rs.close();
                st.close();
                rs = null;
                st = null;
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    protected Justificacion buscaPrimerPermisoFecha(int codigo, int division, int sexo, Date fecha) {
        try {
            String query = "SELECT P.COD_PERMISO_DIA, P.COD_TIPO_PERMISO, P.MODALIDAD, T.NOMBRE_TIPO_PERMISO FROM PERSONAL_PERMISOS_DIA P INNER JOIN TIPOS_PERMISO T ON (P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE COD_PERSONAL=" + codigo + " AND '" + TimeFunction.formatearFecha(fecha) + "' BETWEEN FECHA_INICIO AND FECHA_FIN";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);

            //ResultSet rs = this.ejecutaConsulta(query);

            if (rs.next()) {
                //Justificacion p ="PERMISO", rs.getString("NOMBRE_TIPO_PERMISO"), rs.getInt("MODALIDAD"), TimeFunction.minutosTurno(1, division, sexo, codigo));
                Justificacion j = (new Justificacion("PERMISO", rs.getString("NOMBRE_TIPO_PERMISO"), rs.getInt("MODALIDAD"), TimeFunction.minutosTurno(1, division, sexo, codigo)));
                rs.close();
                st.close();
                rs = null;
                st = null;

                return j;

            } else {
                rs.close();
                st.close();
                rs = null;
                st = null;
                return null;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Justificacion buscaSegundoPermisoFecha(int codigo, int division, int sexo, Date fecha) {
        try {
            String query = "SELECT P.COD_PERMISO_DIA, P.COD_TIPO_PERMISO, P.MODALIDAD, T.NOMBRE_TIPO_PERMISO FROM PERSONAL_PERMISOS_DIA P INNER JOIN TIPOS_PERMISO T ON (P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE COD_PERSONAL=" + codigo + " AND '" + TimeFunction.formatearFecha(fecha) + "' BETWEEN FECHA_INICIO AND FECHA_FIN";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            if (rs.next()) {
                Justificacion j = (new Justificacion("PERMISO", rs.getString("NOMBRE_TIPO_PERMISO"), rs.getInt("MODALIDAD"), TimeFunction.minutosTurno(2, division, sexo, codigo)));
                rs.close();
                st.close();
                rs = null;
                st = null;
                return j;
            } else {
                rs.close();
                st.close();
                rs = null;
                st = null;
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();

            return null;
        }
    }

    protected Justificacion buscaSegundoPermiso(int codigo, int division, int sexo, Date fecha) {
        try {
            String query = "SELECT P.TURNO_PERMISO, P.MODALIDAD, T.NOMBRE_TIPO_PERMISO FROM PERSONAL_PERMISOS_TURNO P INNER JOIN TIPOS_PERMISO T ON (P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE COD_PERSONAL=" + codigo + " AND ((TURNO_PERMISO=2) OR (TURNO_PERMISO=3)) AND FECHA_PERMISO='" + TimeFunction.formatearFecha(fecha) + "'";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            if (rs.next()) {
                Justificacion j = (new Justificacion("PERMISO", rs.getString("NOMBRE_TIPO_PERMISO"), rs.getInt("MODALIDAD"), TimeFunction.minutosTurno(2, division, sexo, codigo)));
                rs.close();
                st.close();
                rs = null;
                st = null;
                return j;
            } else {
                rs.close();
                st.close();
                rs = null;
                st = null;
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    protected Justificacion buscaPrimerVacacion(int codigo, int division, int sexo, Date fecha) {
        /* CODIGO A CORREGIR CONSTANTEMENTE */
        int resultado = 0;
        try {
            String igual_inicio = "SELECT COD_DIA_TOMADO, TIPO_VACACION_INICIO, TURNO_INICIO FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND FECHA_INICIO_VACACION= '" + TimeFunction.formatearFecha(fecha) + "'";
            Statement st = this.connection.createStatement();
            ResultSet rs_igual_inicio = st.executeQuery(igual_inicio);
            //ResultSet rs_igual_inicio = this.ejecutaConsulta(igual_inicio);
            if (rs_igual_inicio.next()) {
                if (rs_igual_inicio.getInt("TIPO_VACACION_INICIO") == 1) {
                    st.close();
                    st = null;
                    rs_igual_inicio.close();
                    rs_igual_inicio = null;
                    return new Justificacion("VACACION", "VACACION", 6, TimeFunction.minutosTurno(1, division, sexo, codigo));
                } else {
                    if (rs_igual_inicio.getInt("TURNO_INICIO") == 2) {
                        st.close();
                        st = null;
                        rs_igual_inicio.close();
                        rs_igual_inicio = null;
                        return new Justificacion("VACACION", "VACACION", 6, TimeFunction.minutosTurno(1, division, sexo, codigo));
                    } else {
                        st.close();
                        st = null;
                        rs_igual_inicio.close();
                        rs_igual_inicio = null;
                        return null;
                    }
                }
            } else {
                String igual_final = "SELECT COD_DIA_TOMADO, TIPO_VACACION_FINAL FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND FECHA_FINAL_VACACION= '" + TimeFunction.formatearFecha(fecha) + "'";
                st = this.connection.createStatement();
                ResultSet rs_igual_final = st.executeQuery(igual_final);
                //ResultSet rs_igual_final = this.ejecutaConsulta(igual_final);
                if (rs_igual_final.next()) {
                    if (rs_igual_final.getInt("TIPO_VACACION_FINAL") < 3) {
                        st.close();
                        st = null;
                        rs_igual_final.close();
                        rs_igual_final = null;
                        return new Justificacion("VACACION", "VACACION", 6, TimeFunction.minutosTurno(1, division, sexo, codigo));
                    } else {
                        st.close();
                        st = null;
                        rs_igual_final.close();
                        rs_igual_final = null;
                        return null;
                    }
                } else {
                    String entre_intervalo = "SELECT COD_DIA_TOMADO, TIPO_VACACION_FINAL FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND '" + TimeFunction.formatearFecha(fecha) + "' BETWEEN FECHA_INICIO_VACACION AND FECHA_FINAL_VACACION";
                    st = this.connection.createStatement();
                    ResultSet rs_entre_intervalo = st.executeQuery(entre_intervalo);
                    //ResultSet rs_entre_intervalo = this.ejecutaConsulta(entre_intervalo);
                    if (rs_entre_intervalo.next()) {
                        st.close();
                        st = null;
                        rs_entre_intervalo.close();
                        rs_entre_intervalo = null;
                        return new Justificacion("VACACION", "VACACION", 6, TimeFunction.minutosTurno(1, division, sexo, codigo));
                    } else {
                        st.close();
                        st = null;
                        rs_entre_intervalo.close();
                        rs_entre_intervalo = null;
                        return null;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    protected Justificacion buscaSegundoVacacion(int codigo, int division, int sexo, Date fecha) {
        /* CODIGO A CORREGIR CONSTANTEMENTE */
        int resultado = 0;
        try {
            String igual_inicio = "SELECT COD_DIA_TOMADO, TIPO_VACACION_INICIO, TURNO_INICIO FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND FECHA_INICIO_VACACION= '" + TimeFunction.formatearFecha(fecha) + "'";
            Statement st = this.connection.createStatement();
            ResultSet rs_igual_inicio = st.executeQuery(igual_inicio);

            //ResultSet rs_igual_inicio = this.ejecutaConsulta(igual_inicio);
            if (rs_igual_inicio.next()) {
                if (rs_igual_inicio.getInt("TIPO_VACACION_INICIO") == 1) {
                    Justificacion j = new Justificacion("VACACION", "VACACION", 6, TimeFunction.minutosTurno(2, division, sexo, codigo));
                    st.close();
                    st = null;
                    rs_igual_inicio.close();
                    rs_igual_inicio = null;
                    return j;
                } else {
                    if (rs_igual_inicio.getInt("TURNO_INICIO") == 1) {
                        Justificacion j = new Justificacion("VACACION", "VACACION", 6, TimeFunction.minutosTurno(2, division, sexo, codigo));
                        st.close();
                        st = null;
                        rs_igual_inicio.close();
                        rs_igual_inicio = null;
                        return j;
                    } else {
                        st.close();
                        st = null;
                        rs_igual_inicio.close();
                        rs_igual_inicio = null;
                        return null;
                    }
                }
            } else {
                String igual_final = "SELECT COD_DIA_TOMADO, TIPO_VACACION_FINAL FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND FECHA_FINAL_VACACION= '" + TimeFunction.formatearFecha(fecha) + "'";
                st = this.connection.createStatement();
                ResultSet rs_igual_final = st.executeQuery(igual_final);
                //ResultSet rs_igual_final = this.ejecutaConsulta(igual_final);
                if (rs_igual_final.next()) {
                    if (rs_igual_final.getInt("TIPO_VACACION_FINAL") == 1) {
                        Justificacion j = new Justificacion("VACACION", "VACACION", 6, TimeFunction.minutosTurno(2, division, sexo, codigo));
                        st.close();
                        st = null;
                        rs_igual_final.close();
                        rs_igual_final = null;
                        return j;
                    } else {
                        st.close();
                        st = null;
                        rs_igual_final.close();
                        rs_igual_final = null;
                        return null;
                    }
                } else {
                    String entre_intervalo = "SELECT COD_DIA_TOMADO, TIPO_VACACION_FINAL FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND '" + TimeFunction.formatearFecha(fecha) + "' BETWEEN FECHA_INICIO_VACACION AND FECHA_FINAL_VACACION";
                    st = this.connection.createStatement();
                    ResultSet rs_entre_intervalo = st.executeQuery(entre_intervalo);
                    //ResultSet rs_entre_intervalo = this.ejecutaConsulta(entre_intervalo);
                    if (rs_entre_intervalo.next()) {
                        Justificacion j = new Justificacion("VACACION", "VACACION", 6, TimeFunction.minutosTurno(2, division, sexo, codigo));
                        st.close();
                        st = null;
                        rs_entre_intervalo.close();
                        rs_entre_intervalo = null;
                        return j;
                    } else {
                        st.close();
                        st = null;
                        rs_entre_intervalo.close();
                        rs_entre_intervalo = null;
                        return null;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /*protected int calculaMinutosPermisoDia(int codigo, Date inicio){
    try{
    String query = "SELECT FECHA_PERMISO, HORA_INICIO, HORA_FIN FROM PERSONAL_PERMISOS WHERE COD_PERSONAL=" + codigo + " AND (MODALIDAD=1 OR MODALIDAD=2) AND FECHA_PERMISO='" + TimeFunction.formatearFecha(inicio)+ "'";
    ResultSet resultSet = ejecutaConsulta(query);
    int resultado = 0;
    while(resultSet.next()){
    DateTime horaInicio = TimeFunction.convertirDateTime(resultSet.getDate("FECHA_PERMISO"), resultSet.getString("HORA_INICIO"));
    DateTime horaFin = TimeFunction.convertirDateTime(resultSet.getDate("FECHA_PERMISO"), resultSet.getString("HORA_FIN"));
    resultado += TimeFunction.diferenciaTiempo(horaFin, horaInicio);
    }
    String permisos_turno = "SELECT FECHA_PERMISO, TURNO_PERMISO FROM PERSONAL_PERMISOS_TURNO WHERE COD_PERSONAL=" + codigo + " AND (MODALIDAD=1 OR MODALIDAD=2) AND FECHA_PERMISO='" + TimeFunction.formatearFecha(inicio)+ "'";
    ResultSet rs_permisos_turno = ejecutaConsulta(permisos_turno);
    while(resultSet.next()){
    int total_minutos = 0;
    switch(rs_permisos_turno.getInt("TURNO_PERMISO")){
    case 1:
    total_minutos = 240;
    break;
    case 2:
    total_minutos = 240;
    break;
    case 3:
    total_minutos = 480;
    break;
    }
    resultado += total_minutos;
    }
    return resultado;
    }catch(Exception e){
    e.printStackTrace();
    return 0;
    }
    }*/
    /* CALCULA TOTAL MINUTOS DESCUENTO DE UNA FECHA DETERMINADA */
    /*public int calculaMinutosPermisoDescuentoDia(int codigo, Date inicio){
    try{
    String query = "SELECT FECHA_PERMISO, HORA_INICIO, HORA_FIN FROM PERSONAL_PERMISOS WHERE COD_PERSONAL=" + codigo + " AND MODALIDAD=2 AND FECHA_PERMISO='" + TimeFunction.formatearFecha(inicio)+ "'";
    ResultSet resultSet = ejecutaConsulta(query);
    int resultado = 0;
    while(resultSet.next()){
    DateTime horaInicio = TimeFunction.convertirDateTime(resultSet.getDate("FECHA_PERMISO"), resultSet.getString("HORA_INICIO"));
    DateTime horaFin = TimeFunction.convertirDateTime(resultSet.getDate("FECHA_PERMISO"), resultSet.getString("HORA_FIN"));
    resultado += TimeFunction.diferenciaTiempo(horaFin, horaInicio);
    }
    String permisos_turno = "SELECT FECHA_PERMISO, TURNO_PERMISO FROM PERSONAL_PERMISOS_TURNO WHERE COD_PERSONAL=" + codigo + " AND MODALIDAD=2 AND FECHA_PERMISO='" + TimeFunction.formatearFecha(inicio)+ "'";
    ResultSet rs_permisos_turno = ejecutaConsulta(permisos_turno);
    while(resultSet.next()){
    int total_minutos = 0;
    switch(rs_permisos_turno.getInt("TURNO_PERMISO")){
    case 1:
    total_minutos = 240;
    break;
    case 2:
    total_minutos = 240;
    break;
    case 3:
    total_minutos = 480;
    break;
    }
    resultado += total_minutos;
    }
    return resultado;
    }catch(Exception e){
    e.printStackTrace();
    return 0;
    }
    }*/
    protected List<PermisoHorario> buscaPermisosDia(int codigo, Date fecha) {
        try {
            String query = "SELECT HORA_INICIO, HORA_FIN, MODALIDAD FROM PERSONAL_PERMISOS WHERE COD_PERSONAL=" + codigo + " AND FECHA_PERMISO='" + TimeFunction.formatearFecha(fecha) + "'";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            //ResultSet rs = this.ejecutaConsulta(query);
            List<PermisoHorario> resultList = new ArrayList();
            while (rs.next()) {
                resultList.add(new PermisoHorario(TimeFunction.convertirDateTime(fecha, rs.getString("HORA_INICIO")), TimeFunction.convertirDateTime(fecha, rs.getString("HORA_FIN")), rs.getInt("MODALIDAD")));
            }
            rs.close();
            st.close();
            rs = null;
            st = null;
            return (resultList.size() > 0 ? resultList : null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    protected boolean buscaHorarioMaternidad(int codigo, Date fecha) {
        try {
            String query = "SELECT COD_PERSONAL FROM PERSONAL_MATERNIDAD WHERE COD_PERSONAL=" + codigo + " AND '" + TimeFunction.formatearFecha(fecha) + "' BETWEEN FECHA_INICIO AND FECHA_FIN";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);

            //ResultSet rs = this.ejecutaConsulta(query);
            return (rs.next());
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    protected int calculaMinutosReemplazable(int codigo, Date inicio, Date fin) {
        try {
            String query = "SELECT FECHA_PERMISO, HORA_INICIO, HORA_FIN FROM PERSONAL_PERMISOS WHERE COD_PERSONAL=" + codigo + " AND MODALIDAD=1 AND FECHA_PERMISO BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "'";
            Statement st = this.connection.createStatement();
            ResultSet resultSet = st.executeQuery(query);
            //ResultSet resultSet = ejecutaConsulta(query);
            int resultado = 0;
            while (resultSet.next()) {
                DateTime horaInicio = TimeFunction.convertirDateTime(resultSet.getDate("FECHA_PERMISO"), resultSet.getString("HORA_INICIO"));
                DateTime horaFin = TimeFunction.convertirDateTime(resultSet.getDate("FECHA_PERMISO"), resultSet.getString("HORA_FIN"));
                resultado += TimeFunction.diferenciaTiempo(horaFin, horaInicio);
            }
            st.close();
            st = null;
            resultSet.close();
            resultSet = null;
            System.gc();
            return resultado;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int calculaMinutosDescontados(int codigo, Date inicio, Date fin, int division, int sexo) {
        try {
            String query = "SELECT FECHA_PERMISO, HORA_INICIO, HORA_FIN FROM PERSONAL_PERMISOS WHERE COD_PERSONAL=" + codigo + " AND MODALIDAD=2 AND FECHA_PERMISO BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "'";
            System.out.println("query hora:"+query);
            Statement st = this.connection.createStatement();
            ResultSet resultSet = st.executeQuery(query);
            //ResultSet resultSet = ejecutaConsulta(query);
            int resultado = 0;
            while (resultSet.next()) {
                DateTime horaInicio = TimeFunction.convertirDateTime(resultSet.getDate("FECHA_PERMISO"), resultSet.getString("HORA_INICIO"));
                DateTime horaFin = TimeFunction.convertirDateTime(resultSet.getDate("FECHA_PERMISO"), resultSet.getString("HORA_FIN"));
                resultado = resultado + TimeFunction.diferenciaTiempo(horaFin, horaInicio);
            }
            String permisos_turno = "SELECT FECHA_PERMISO, TURNO_PERMISO FROM PERSONAL_PERMISOS_TURNO WHERE COD_PERSONAL=" + codigo + " AND MODALIDAD=2 AND FECHA_PERMISO BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "'";
            System.out.println("permisos_turno turno:"+permisos_turno);
            st = this.connection.createStatement();
            ResultSet rs_permisos_turno = st.executeQuery(permisos_turno);

            //ResultSet rs_permisos_turno = ejecutaConsulta(permisos_turno);
            int total_minutos = 0;
            while (rs_permisos_turno.next()) {
                switch (rs_permisos_turno.getInt("TURNO_PERMISO")) {
                    case 1:
                        resultado = resultado + TimeFunction.minutosTurno(1, division, sexo, codigo);
                        break;
                    case 2:
                        resultado = resultado + TimeFunction.minutosTurno(2, division, sexo, codigo);
                        break;
                    case 3:
                        resultado = resultado + TimeFunction.minutosTurno(1, division, sexo, codigo) + TimeFunction.minutosTurno(2, division, sexo, codigo);
                        break;
                }
            }
            DateTime f_inicio = new DateTime(inicio).minusDays(1);
            DateTime f_fin = new DateTime(fin).plusDays(1);
            String permisos_fecha = "SELECT FECHA_INICIO, FECHA_FIN FROM PERSONAL_PERMISOS_DIA WHERE COD_PERSONAL=" + codigo + " AND MODALIDAD=2 AND ((FECHA_INICIO>'" + TimeFunction.formatearFecha(f_inicio.toDate()) + "' AND FECHA_INICIO<'" + TimeFunction.formatearFecha(f_fin.toDate()) + "') OR (FECHA_INICIO<'" + TimeFunction.formatearFecha(new DateTime(inicio).toDate()) + "' AND FECHA_FIN>'" + TimeFunction.formatearFecha(f_inicio.toDate()) + "'))";
            System.out.println("permisos_fecha:"+permisos_fecha);
            System.out.println(permisos_fecha);
            st = this.connection.createStatement();
            ResultSet rs_permisos_fecha = st.executeQuery(permisos_fecha);

            //ResultSet rs_permisos_fecha = ejecutaConsulta(permisos_fecha);
            while (rs_permisos_fecha.next()) {
                DateTime comienzo = new DateTime(rs_permisos_fecha.getDate("FECHA_INICIO"));
                if (comienzo.isBefore(new DateTime(inicio))) {
                    comienzo = new DateTime(inicio);
                }
                DateTime conclusion = new DateTime(rs_permisos_fecha.getDate("FECHA_FIN")).plusDays(1);
                while (comienzo.isBefore(conclusion) && comienzo.isBefore(f_fin)) {
                    if (this.isDiaLaboral(comienzo.toDate(), division, sexo, codigo)) {
                        resultado = resultado + TimeFunction.minutosTurno(1, division, sexo, codigo) + TimeFunction.minutosTurno(2, division, sexo, codigo);
                    }
                    comienzo = comienzo.plusDays(1);
                }
            }
            rs_permisos_fecha.close();
            rs_permisos_turno.close();
            resultSet.close();
            return (resultado + total_minutos);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int calculaMinutosSinReemplazoDescuento(int codigo, Date inicio, Date fin, int division, int sexo) {
        try {
            String query = "SELECT FECHA_PERMISO, HORA_INICIO, HORA_FIN FROM PERSONAL_PERMISOS WHERE COD_PERSONAL=" + codigo + " AND MODALIDAD=3 AND FECHA_PERMISO BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "'";
            Statement st = this.connection.createStatement();
            ResultSet resultSet = st.executeQuery(query);
            //ResultSet resultSet = ejecutaConsulta(query);
            int resultado = 0;
            while (resultSet.next()) {
                DateTime horaInicio = TimeFunction.convertirDateTime(resultSet.getDate("FECHA_PERMISO"), resultSet.getString("HORA_INICIO"));
                DateTime horaFin = TimeFunction.convertirDateTime(resultSet.getDate("FECHA_PERMISO"), resultSet.getString("HORA_FIN"));
                resultado = resultado + TimeFunction.diferenciaTiempo(horaFin, horaInicio);
            }
            String permisos_turno = "SELECT FECHA_PERMISO, TURNO_PERMISO FROM PERSONAL_PERMISOS_TURNO WHERE COD_PERSONAL=" + codigo + " AND MODALIDAD=3 AND FECHA_PERMISO BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "'";
            st = this.connection.createStatement();
            ResultSet rs_permisos_turno = st.executeQuery(permisos_turno);
            //ResultSet rs_permisos_turno = ejecutaConsulta(permisos_turno);
            int total_minutos = 0;
            while (rs_permisos_turno.next()) {
                resultado = resultado + TimeFunction.minutosTurno(rs_permisos_turno.getInt("TURNO_PERMISO"), division, sexo, codigo);
            }
            rs_permisos_turno.close();
            resultSet.close();
            st.close();
            rs_permisos_turno = null;
            System.gc();
            return resultado;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<PermisoFecha> listaPermisosFecha(int codigo_personal) {
        try {
            String query = "SELECT P.COD_PERMISO_DIA, P.FECHA_INICIO, P.FECHA_FIN, T.NOMBRE_TIPO_PERMISO, P.OBS, P.MODALIDAD, P.NUMERO_BOLETA ";
            query += "FROM PERSONAL_PERMISOS_DIA P INNER JOIN TIPOS_PERMISO T ON(P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE P.COD_PERSONAL=" + codigo_personal + " ORDER BY P.COD_PERMISO_DIA DESC";
            List<PermisoFecha> resultList = new ArrayList();
            Statement st = this.connection.createStatement();
            ResultSet resultSet = st.executeQuery(query);
            //ResultSet resultSet = ejecutaConsulta(query);
            while (resultSet.next()) {
                resultList.add(new PermisoFecha(resultSet.getInt("COD_PERMISO_DIA"), codigo_personal, resultSet.getDate("FECHA_INICIO"), resultSet.getDate("FECHA_FIN"), resultSet.getString("OBS"), resultSet.getString("NOMBRE_TIPO_PERMISO"), resultSet.getInt("MODALIDAD"), resultSet.getInt("NUMERO_BOLETA")));
            }
            resultSet.close();
            resultSet = null;
            st.close();
            st = null;
            return (resultList.size() > 0 ? resultList : null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    protected List listaPermisosFecha(int codigo_personal, Date inicio, Date fin) {
        ResultSet resultSet = null;
        try {
            String query = "SELECT P.COD_PERMISO, P.FECHA_PERMISO, T.NOMBRE_TIPO_PERMISO, P.HORA_INICIO, P.HORA_FIN, P.MODALIDAD, P.OBS, P.NUMERO_BOLETA ";
            query += "FROM PERSONAL_PERMISOS P INNER JOIN TIPOS_PERMISO T ON(P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE P.COD_PERSONAL=" + codigo_personal + " AND FECHA_PERMISO BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' ORDER BY P.COD_PERMISO DESC";
            List resultList = new ArrayList();
            Statement st = this.connection.createStatement();
            //resultSet = ejecutaConsulta(query);
            resultSet = st.executeQuery(query);
            while (resultSet.next()) {
                resultList.add(new Permiso(resultSet.getInt("COD_PERMISO"), codigo_personal, resultSet.getDate("FECHA_PERMISO"), resultSet.getString("NOMBRE_TIPO_PERMISO"), resultSet.getString("HORA_INICIO"), resultSet.getString("HORA_FIN"), resultSet.getString("OBS"), resultSet.getInt("MODALIDAD"), resultSet.getInt("NUMERO_BOLETA")));
            }
            resultSet.close();
            st.close();
            resultSet = null;
            System.gc();
            return (resultList.size() > 0 ? resultList : null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /* AGREGADOS PARA CENTRALIZAR LOS PROCESOS */
    protected Asistencia generaAsistenciaDia(int codigo, int sexo, int division, Date fecha, double promedioDevolucion, boolean confianza) {
        ResultSet rs = null;
        try {
            String query = "SELECT FECHA_ASISTENCIA, HORA_INGRESO1, HORA_SALIDA1, HORA_INGRESO2, HORA_SALIDA2 FROM CONTROL_ASISTENCIA WHERE COD_PERSONAL=" + codigo + " AND FECHA_ASISTENCIA='" + TimeFunction.formatearFecha(fecha) + "'";
            System.out.println("query:" + query);
            Statement st = this.connection.createStatement();
            rs = st.executeQuery(query);
            //rs = ejecutaConsulta(query);
            DateTime ingreso1 = null;
            DateTime salida1 = null;
            DateTime ingreso2 = null;
            DateTime salida2 = null;
            if (rs.next()) {
                ingreso1 = rs.getTimestamp("HORA_INGRESO1") != null ? new DateTime(rs.getTimestamp("HORA_INGRESO1")) : null;
                salida1 = rs.getTimestamp("HORA_SALIDA1") != null ? new DateTime(rs.getTimestamp("HORA_SALIDA1")) : null;
                ingreso2 = rs.getTimestamp("HORA_INGRESO2") != null ? new DateTime(rs.getTimestamp("HORA_INGRESO2")) : null;
                salida2 = rs.getTimestamp("HORA_SALIDA2") != null ? new DateTime(rs.getTimestamp("HORA_SALIDA2")) : null;
            }
            /* JUSTIFICACION PERMISOS */
            Justificacion pjust = null;
            Justificacion sjust = null;
            if (this.isDiaLaboral(fecha, division, sexo, codigo)) {
                pjust = this.buscaPrimeraJustificacion(codigo, division, sexo, fecha);
                sjust = this.buscaSegundaJustificacion(codigo, division, sexo, fecha);
            } else {
                pjust = this.buscaPrimerFeriado(codigo, division, sexo, fecha);
                sjust = this.buscaSegundoFeriado(codigo, division, sexo, fecha);
            }
            Asistencia asistencia = new Asistencia(codigo, fecha, ingreso1, salida1, ingreso2, salida2, sexo, division, pjust, sjust, this.buscaPermisosDia(codigo, fecha), this.buscaHorarioMaternidad(codigo, fecha), confianza);
            st.close();
            st = null;
            rs.close();
            rs = null;
            return asistencia;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
///////////2//234/2/3

    public Personal listaAsistenciaEmpleadoIndividual(int codigo, Date inicio, Date fin) {
        try {
            Personal personal = this.buscarPersonal(codigo);
            if ((personal != null) && (inicio != null) && (fin != null)) {
                DateTime inicioIntervalo = new DateTime(inicio);
                DateTime finIntervalo = new DateTime(fin).plusDays(1);
                List<Asistencia> asistencias = new ArrayList();
                double cont12 = 0;
                double cont8 = 0;
                DateTime inicioContrato = this.fechaInicioContrato(codigo).minusDays(1);
                DateTime finContrato = this.fechaConclusionContrato(codigo);
                finContrato = finContrato.plusDays(1);
                while (inicioIntervalo.isBefore(finIntervalo)) {
                    if (inicioIntervalo.isAfter(inicioContrato) && inicioIntervalo.isBefore(finContrato)) {
                        Asistencia asistencia = this.generaAsistenciaDia(personal.getCodigo(), personal.getSexo(), personal.getDivision(), inicioIntervalo.toDate(), (cont12 > cont8 ? 12.60 : 8.40), personal.isConfianza());
                        asistencias.add(asistencia);
                    } else {
                        Justificacion pjust = null;
                        Justificacion sjust = null;
                        if (inicioIntervalo.getDayOfWeek() < 7) {
                            pjust = new Justificacion("SIN CONTRATO", "SIN CONTRATO", 7, TimeFunction.minutosTurno(1, personal.getDivision(), personal.getSexo(), personal.getCodigo()));
                            sjust = new Justificacion("SIN CONTRATO", "SIN CONTRATO", 7, TimeFunction.minutosTurno(2, personal.getDivision(), personal.getSexo(), personal.getCodigo()));
                        }
                        Asistencia asistencia = new Asistencia(codigo, inicioIntervalo.toDate(), null, null, null, null, personal.getSexo(), personal.getDivision(), pjust, sjust, null, false, personal.isConfianza());
                        asistencias.add(asistencia);
                    }
                    inicioIntervalo = inicioIntervalo.plusDays(1);
                }

                personal.setMinutosSabado(this.contarNumeroSabados(inicio, fin) * 180);
                personal.setAsistencia(asistencias);
                personal.setMinutosReemplazable(this.calculaMinutosReemplazable(personal.getCodigo(), inicio, fin));
                personal.setMinutosReemplazableFuera(0);
                personal.setMinutosDescuento(this.calculaMinutosDescontados(personal.getCodigo(), inicio, fin, personal.getDivision(), personal.getSexo()));
                personal.setMinutosSinReemplazoDescuento(this.calculaMinutosSinReemplazoDescuento(personal.getCodigo(), inicio, fin, personal.getDivision(), personal.getSexo()));
                personal.setPermisos(this.listaPermisosFecha(personal.getCodigo(), inicio, fin));
            }
            return personal;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Personal buscarPersonal(int codigo) {
        try {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + p.NOMBRES_PERSONAL+' '+p.nombre2_personal AS NOMBRE_COMPLETO, P.RECIBE_EXTRAS, ";
            query += " C.DESCRIPCION_CARGO, P.SEXO_PERSONAL, P.CONFIANZA, P.CONTROL_ASISTENCIA, AE.NOMBRE_AREA_EMPRESA, AE.DIVISION FROM PERSONAL P INNER JOIN CARGOS C ON (P.CODIGO_CARGO=C.CODIGO_CARGO) ";
            query += "INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) WHERE P.COD_PERSONAL=" + codigo;
            Statement st = this.connection.createStatement();
            ResultSet resultSet = st.executeQuery(query);
            //ResultSet resultSet = ejecutaConsulta(query);
            if (resultSet.next()) {


                Personal p = (new Personal(resultSet.getInt("COD_PERSONAL"), resultSet.getString("NOMBRE_COMPLETO"), resultSet.getString("DESCRIPCION_CARGO"), resultSet.getInt("SEXO_PERSONAL"), resultSet.getString("NOMBRE_AREA_EMPRESA"), resultSet.getInt("DIVISION"), resultSet.getInt("RECIBE_EXTRAS"), (resultSet.getInt("CONFIANZA") == 1 ? true : false), (resultSet.getInt("CONTROL_ASISTENCIA") == 1 ? true : false)));
                resultSet.close();
                resultSet = null;
                st.close();
                st = null;
                return p;


            } else {
                return null;
            }



        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean excedenteMarcadosFecha(int codigo, Date fecha) {
        boolean x;
        try {
            String query = "SELECT COUNT(A.COD_PERSONAL) AS MARCADOS, A.COD_PERSONAL, A.FECHA FROM ARCHIVOS_ASISTENCIA_DETALLE A WHERE A.COD_ESTADO_REGISTRO=1 AND A.FECHA='" + TimeFunction.formatearFecha(fecha) + "' AND A.HORA>'03:00' AND A.COD_PERSONAL=" + codigo + " GROUP BY A.COD_PERSONAL, A.FECHA ORDER BY MARCADOS";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                x = (rs.getInt("MARCADOS") > 4);

            } else {
                x = false;
            }
            rs.close();
            rs = null;
            st.close();
            st = null;
            return x;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int numeroMarcadosFecha(int codigo, Date fecha) {
        try {
            String query = "SELECT COUNT(A.COD_PERSONAL) AS MARCADOS, A.COD_PERSONAL, A.FECHA FROM ARCHIVOS_ASISTENCIA_DETALLE A WHERE A.COD_ESTADO_REGISTRO=1 AND A.FECHA='" + TimeFunction.formatearFecha(fecha) + "' AND A.HORA>'03:00' AND A.COD_PERSONAL=" + codigo + " GROUP BY A.COD_PERSONAL, A.FECHA ORDER BY MARCADOS";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                int x = (rs.getInt("MARCADOS"));
                rs.close();
                rs = null;
                st.close();
                st = null;
                return (x);
            } else {
                rs.close();
                rs = null;
                st.close();
                st = null;
                return 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public Date fechaInicioMes(int mes, int gestion) {
        try {
            String query = "SELECT ANIO_MENOR, ANIO_MAYOR FROM GESTIONES WHERE COD_GESTION=" + gestion;
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                Date resultado = TimeFunction.convertirCadenaDate(Integer.valueOf(mes > 3 ? rs.getString("ANIO_MENOR") : rs.getString("ANIO_MAYOR")) + "/" + (mes < 10 ? ("0" + mes) : mes) + "/01");
                rs.close();
                rs = null;
                st.close();
                st = null;
                return (resultado);
            } else {
                rs.close();
                rs = null;
                st.close();
                st = null;
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Date fechaFinMes(Date inicio) {
        Date resultado = new DateTime(inicio).plusMonths(1).minusDays(1).toDate();
        return (resultado);
    }

    public Date fechaFinMes(int mes, int gestion) {
        Date fin = this.fechaInicioMes(mes, gestion);
        if (fin != null) {
            Date resultado = this.fechaFinMes(fin);
            return (resultado);
        } else {
            return null;
        }
    }

    protected List listaAreasEmpresaTodos() {
        try {
            String query = "SELECT COD_AREA_EMPRESA, NOMBRE_AREA_EMPRESA FROM AREAS_EMPRESA WHERE COD_AREA_EMPRESA IN(SELECT DISTINCT(COD_AREA_EMPRESA) FROM PERSONAL WHERE COD_AREA_EMPRESA>0) AND COD_ESTADO_REGISTRO=1 ORDER BY NOMBRE_AREA_EMPRESA";
            Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet resultSet = statement.executeQuery(query);
            List resultList = new ArrayList();
            while (resultSet.next()) {
                resultList.add(resultSet.getString("NOMBRE_AREA_EMPRESA"));
            }
            statement.close();
            statement = null;
            resultSet.close();
            resultSet = null;
            return (resultList.size() > 0 ? resultList : null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List listaAreasEmpresaDivision(int codigo) {
        try {
            String query = "SELECT COD_AREA_EMPRESA, NOMBRE_AREA_EMPRESA FROM AREAS_EMPRESA WHERE COD_AREA_EMPRESA IN(SELECT DISTINCT(COD_AREA_EMPRESA) FROM PERSONAL WHERE COD_AREA_EMPRESA>0) AND COD_ESTADO_REGISTRO=1 AND DIVISION=" + codigo + " ORDER BY NOMBRE_AREA_EMPRESA";
            Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet resultSet = statement.executeQuery(query);
            List resultList = new ArrayList();
            while (resultSet.next()) {
                resultList.add(new SelectItem(resultSet.getInt("COD_AREA_EMPRESA"), resultSet.getString("NOMBRE_AREA_EMPRESA")));
            }
            statement.close();
            statement = null;
            resultSet.close();
            resultSet = null;
            return (resultList.size() > 0 ? resultList : null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List listaAreasEmpresaMarcaExtraDivision(int codigo) {
        try {
            String query = "SELECT COD_AREA_EMPRESA, NOMBRE_AREA_EMPRESA FROM AREAS_EMPRESA WHERE COD_AREA_EMPRESA IN(SELECT DISTINCT(COD_AREA_EMPRESA) FROM PERSONAL WHERE COD_AREA_EMPRESA>0 AND CONTROL_ASISTENCIA=1 AND RECIBE_EXTRAS=1 AND COD_ESTADO_PERSONA=1) AND COD_ESTADO_REGISTRO=1 AND DIVISION=" + codigo + " ORDER BY NOMBRE_AREA_EMPRESA";
            Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet resultSet = statement.executeQuery(query);
            List resultList = new ArrayList();
            while (resultSet.next()) {
                resultList.add(new SelectItem(resultSet.getInt("COD_AREA_EMPRESA"), resultSet.getString("NOMBRE_AREA_EMPRESA")));
            }
            statement.close();
            statement = null;
            resultSet.close();
            resultSet = null;
            return (resultList.size() > 0 ? resultList : null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List listaAreasEmpresaMarcaDivision(int codigo) {
        try {
            String query = "SELECT COD_AREA_EMPRESA, NOMBRE_AREA_EMPRESA FROM AREAS_EMPRESA WHERE COD_AREA_EMPRESA IN(SELECT DISTINCT(COD_AREA_EMPRESA) FROM PERSONAL WHERE COD_AREA_EMPRESA>0 AND CONTROL_ASISTENCIA=1 AND COD_ESTADO_PERSONA=1 AND CONFIANZA=2) AND COD_ESTADO_REGISTRO=1 AND DIVISION=" + codigo + " ORDER BY NOMBRE_AREA_EMPRESA";
            System.out.println("LISTADO DE AREAS EMPRESA:" + query);
            Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet resultSet = statement.executeQuery(query);
            List resultList = new ArrayList();
            while (resultSet.next()) {
                resultList.add(new SelectItem(resultSet.getInt("COD_AREA_EMPRESA"), resultSet.getString("NOMBRE_AREA_EMPRESA")));
            }
            statement.close();
            statement = null;
            resultSet.close();
            resultSet = null;
            return (resultList.size() > 0 ? resultList : null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List listaAreasEmpresaRecibeDominical() {
        try {
            String query = "SELECT COD_AREA_EMPRESA, NOMBRE_AREA_EMPRESA FROM AREAS_EMPRESA WHERE COD_AREA_EMPRESA IN(SELECT DISTINCT(P.COD_AREA_EMPRESA) FROM PERSONAL P WHERE P.COD_AREA_EMPRESA>0 AND CONTROL_ASISTENCIA=1 AND P.COD_ESTADO_PERSONA=1 AND P.CONFIANZA=2 AND P.DOMINICAL_PERSONAL=1) AND COD_ESTADO_REGISTRO=1 ORDER BY NOMBRE_AREA_EMPRESA";
            Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet resultSet = statement.executeQuery(query);
            List resultList = new ArrayList();
            while (resultSet.next()) {
                resultList.add(new SelectItem(resultSet.getInt("COD_AREA_EMPRESA"), resultSet.getString("NOMBRE_AREA_EMPRESA")));
            }
            statement.close();
            statement = null;
            resultSet.close();
            resultSet = null;
            return (resultList.size() > 0 ? resultList : null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean isFeriado(Date fecha) {
        try {
            String query = "SELECT NOMBRE_FERIADO FROM FERIADOS WHERE FERIADO_NAL_SI_NO=1 AND FECHA_FERIADO='" + TimeFunction.formatearFecha(fecha) + "'";
            ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int contarNumeroSabados(Date inicio, Date fin) {
        int resultado = 0;
        DateTime fecha_inicio = new DateTime(inicio);
        DateTime fecha_fin = (new DateTime(fin)).plusDays(1);
        while (fecha_inicio.isBefore(fecha_fin)) {
            if (fecha_inicio.getDayOfWeek() == 6 && !this.isFeriado(fecha_inicio.toDate())) {
                resultado++;
            }
            fecha_inicio = fecha_inicio.plusDays(1);
        }
        return resultado;
    }

    /*private int buscaPermisosDescuentoDia(int codigo, int division, int sexo, Date fecha){
    try{
    String query = "SELECT HORA_INICIO, HORA_FIN, MODALIDAD FROM PERSONAL_PERMISOS WHERE COD_PERSONAL=" + codigo + " AND FECHA_PERMISO='" + TimeFunction.formatearFecha(fecha) + "' AND MODALIDAD=2";
    ResultSet rs = this.ejecutaConsulta(query);
    int total_descuento = 0;
    while(rs.next()){
    total_descuento += TimeFunction.diferenciaTiempo(TimeFunction.convertirDateTime(fecha, rs.getString("HORA_INICIO")), TimeFunction.convertirDateTime(fecha, rs.getString("HORA_FIN")));
    }
    Justificacion pjust = this.buscaPrimeraJustificacionDescuento(codigo, division, sexo, fecha);
    if(pjust.getTipo()==2){
    total_descuento += pjust.getMinutos();
    }
    pjust = this.buscaSegundaJustificacionDescuento(codigo, division, sexo, fecha);
    if(pjust.getTipo()==2){
    total_descuento += pjust.getMinutos();
    }
    return total_descuento;
    }catch(Exception e){
    e.printStackTrace();
    return 0;
    }
    }*/
    public int totalMinutosDescuentoDia(int codigo, int division, int sexo, Date fecha) {
        ResultSet rs = null;
        try {
            String query = "SELECT HORA_INICIO, HORA_FIN, MODALIDAD FROM PERSONAL_PERMISOS WHERE COD_PERSONAL=" + codigo + " AND FECHA_PERMISO='" + TimeFunction.formatearFecha(fecha) + "' AND MODALIDAD=2";
            Statement st = this.connection.createStatement();
            rs = st.executeQuery(query);

            //rs = this.ejecutaConsulta(query);

            int total_descuento = 0;
            while (rs.next()) {
                total_descuento += TimeFunction.diferenciaTiempo(TimeFunction.convertirDateTime(fecha, rs.getString("HORA_INICIO")), TimeFunction.convertirDateTime(fecha, rs.getString("HORA_FIN")));
            }
            Justificacion pjust = this.buscaPrimeraJustificacionDescuento(codigo, division, sexo, fecha);
            total_descuento += (pjust != null ? pjust.getMinutos() : 0);
            pjust = this.buscaSegundaJustificacionDescuento(codigo, division, sexo, fecha);
            total_descuento += (pjust != null ? pjust.getMinutos() : 0);
            rs.close();
            rs = null;
            st.close();
            st = null;
            return total_descuento;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    protected Justificacion buscaPrimeraJustificacionDescuento(int codigo, int division, int sexo, Date fecha) {
        Justificacion j = this.buscaPrimerPermisoDescuento(codigo, division, sexo, fecha);
        if (j != null) {
            return j;
        } else {
            j = this.buscaPrimerPermisoDescuentoFecha(codigo, division, sexo, fecha);
            return j;
        }
    }

    protected Justificacion buscaPrimerPermisoDescuento(int codigo, int division, int sexo, Date fecha) {
        try {
            String query = "SELECT P.TURNO_PERMISO, P.MODALIDAD, T.NOMBRE_TIPO_PERMISO FROM PERSONAL_PERMISOS_TURNO P INNER JOIN TIPOS_PERMISO T ON (P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE COD_PERSONAL=" + codigo + " AND ((TURNO_PERMISO=1) OR (TURNO_PERMISO=3)) AND FECHA_PERMISO='" + TimeFunction.formatearFecha(fecha) + "' AND MODALIDAD=2";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                Justificacion j = (new Justificacion("PERMISO", rs.getString("NOMBRE_TIPO_PERMISO"), rs.getInt("MODALIDAD"), TimeFunction.minutosTurno(1, division, sexo, codigo)));

                st.close();
                st = null;
                rs.close();
                rs = null;
                return (j);
            } else {

                st.close();
                st = null;
                rs.close();
                rs = null;
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    protected Justificacion buscaPrimerPermisoDescuentoFecha(int codigo, int division, int sexo, Date fecha) {
        try {
            String query = "SELECT P.COD_PERMISO_DIA, P.COD_TIPO_PERMISO, P.MODALIDAD, T.NOMBRE_TIPO_PERMISO FROM PERSONAL_PERMISOS_DIA P INNER JOIN TIPOS_PERMISO T ON (P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE COD_PERSONAL=" + codigo + " AND '" + TimeFunction.formatearFecha(fecha) + "' BETWEEN FECHA_INICIO AND FECHA_FIN AND P.MODALIDAD=2";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                Justificacion j = (new Justificacion("PERMISO", rs.getString("NOMBRE_TIPO_PERMISO"), rs.getInt("MODALIDAD"), TimeFunction.minutosTurno(1, division, sexo, codigo)));

                st.close();
                st = null;
                rs.close();
                rs = null;
                return (j);
            } else {

                st.close();
                st = null;
                rs.close();
                rs = null;
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    protected Justificacion buscaSegundaJustificacionDescuento(int codigo, int division, int sexo, Date fecha) {
        Justificacion j = this.buscaSegundoPermisoDescuento(codigo, division, sexo, fecha);
        if (j != null) {
            return j;
        } else {
            j = this.buscaSegundoPermisoDescuentoFecha(codigo, division, sexo, fecha);
            return j;
        }
    }

    protected Justificacion buscaSegundoPermisoDescuento(int codigo, int division, int sexo, Date fecha) {
        try {
            String query = "SELECT P.TURNO_PERMISO, P.MODALIDAD, T.NOMBRE_TIPO_PERMISO FROM PERSONAL_PERMISOS_TURNO P INNER JOIN TIPOS_PERMISO T ON (P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE COD_PERSONAL=" + codigo + " AND ((TURNO_PERMISO=2) OR (TURNO_PERMISO=3)) AND FECHA_PERMISO='" + TimeFunction.formatearFecha(fecha) + "' AND P.MODALIDAD=2";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);

            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                Justificacion j = (new Justificacion("PERMISO", rs.getString("NOMBRE_TIPO_PERMISO"), rs.getInt("MODALIDAD"), TimeFunction.minutosTurno(2, division, sexo, codigo)));

                st.close();
                st = null;
                rs.close();
                rs = null;
                return (j);
            } else {

                st.close();
                st = null;
                rs.close();
                rs = null;
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Justificacion buscaSegundoPermisoDescuentoFecha(int codigo, int division, int sexo, Date fecha) {
        try {
            String query = "SELECT P.COD_PERMISO_DIA, P.COD_TIPO_PERMISO, P.MODALIDAD, T.NOMBRE_TIPO_PERMISO FROM PERSONAL_PERMISOS_DIA P INNER JOIN TIPOS_PERMISO T ON (P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE COD_PERSONAL=" + codigo + " AND '" + TimeFunction.formatearFecha(fecha) + "' BETWEEN FECHA_INICIO AND FECHA_FIN AND P.MODALIDAD=2";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);

            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                Justificacion j = (new Justificacion("PERMISO", rs.getString("NOMBRE_TIPO_PERMISO"), rs.getInt("MODALIDAD"), TimeFunction.minutosTurno(2, division, sexo, codigo)));

                st.close();
                st = null;
                rs.close();
                rs = null;
                return (j);
            } else {

                st.close();
                st = null;
                rs.close();
                rs = null;
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List listaMesesDeGestion(DateTime inicio, DateTime fin) {
        try {
            int cod_mes_inicio = inicio.getMonthOfYear();
            int cod_gestion_inicio = this.obtenerCodigoGestion(inicio);
            int cod_mes_fin = fin.getMonthOfYear();
            int cod_gestion_fin = this.obtenerCodigoGestion(fin);
            boolean salir = false;
            List<MesGestion> resultList = new ArrayList();
            while (!salir) {
                String nombre_del_mes = "SELECT M.ABREVIATURA_MES FROM MESES M WHERE M.COD_MES=" + cod_mes_inicio;
                Statement st = this.connection.createStatement();
                ResultSet rs_nm = st.executeQuery(nombre_del_mes);
                //ResultSet rs_nm = this.ejecutaConsulta(nombre_del_mes);
                rs_nm.next();
                resultList.add(new MesGestion(cod_mes_inicio, cod_gestion_inicio, rs_nm.getString("ABREVIATURA_MES")));
                cod_mes_inicio++;
                if (cod_mes_inicio > 12) {
                    cod_mes_inicio = 1;
                }
                if (cod_mes_inicio == 4) {
                    cod_gestion_inicio++;
                }
                if (cod_gestion_inicio == cod_gestion_fin && cod_mes_inicio == cod_mes_fin) {
                    salir = true;
                }
            }
            String nombre_del_mes = "SELECT M.ABREVIATURA_MES FROM MESES M WHERE M.COD_MES=" + cod_mes_inicio;
            Statement st = this.connection.createStatement();
            ResultSet rs_nm = st.executeQuery(nombre_del_mes);
            //ResultSet rs_nm = this.ejecutaConsulta(nombre_del_mes);
            if (rs_nm.next()) {
                resultList.add(new MesGestion(cod_mes_inicio, cod_gestion_inicio, rs_nm.getString("ABREVIATURA_MES")));
            }
            st.close();
            st = null;
            rs_nm.close();
            rs_nm = null;
            return (resultList.size() > 0 ? resultList : null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public int obtenerCodigoGestion(DateTime fecha) {
        int g;
        try {
            String nombre_gestion = (fecha.getMonthOfYear() < 4 ? "ANIO_MAYOR" : "ANIO_MENOR");
            String consulta_gestion = "SELECT COD_GESTION FROM GESTIONES WHERE " + nombre_gestion + "='" + fecha.getYear() + "'";
            Statement st = this.connection.createStatement();
            ResultSet rs_fg = st.executeQuery(consulta_gestion);
            //ResultSet rs_fg = this.ejecutaConsulta(consulta_gestion);
            if (rs_fg.next()) {
                g= (rs_fg.getInt("COD_GESTION"));
            } else {
                g= 0;
            }
            st.close();
            st = null;
            rs_fg.close();
            rs_fg = null;
            return g;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /* AGREGADOS PARA MEJORAR VELOCIDAD DEL SISTEMA */
    public boolean existePrimerVacacion(int codigo, int division, int sexo, Date fecha) {
        try {
            String igual_inicio = "SELECT COD_DIA_TOMADO, TIPO_VACACION_INICIO, TURNO_INICIO FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND FECHA_INICIO_VACACION= '" + TimeFunction.formatearFecha(fecha) + "'";
            Statement st = this.connection.createStatement();
            ResultSet rs_igual_inicio = st.executeQuery(igual_inicio);
            //ResultSet rs_igual_inicio = this.ejecutaConsulta(igual_inicio);
            if (rs_igual_inicio.next()) {
                if (rs_igual_inicio.getInt("TIPO_VACACION_INICIO") == 1) {
                    rs_igual_inicio.close();
                    rs_igual_inicio = null;
                    st.close();
                    st = null;
                    return true;
                } else {
                    if (rs_igual_inicio.getInt("TURNO_INICIO") == 2) {
                        rs_igual_inicio.close();
                        rs_igual_inicio = null;
                        st.close();
                        st = null;
                        return true;
                    } else {
                        rs_igual_inicio.close();
                        rs_igual_inicio = null;
                        st.close();
                        st = null;
                        return false;
                    }
                }
            } else {
                String igual_final = "SELECT COD_DIA_TOMADO, TIPO_VACACION_FINAL FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND FECHA_FINAL_VACACION= '" + TimeFunction.formatearFecha(fecha) + "'";
                st = this.connection.createStatement();
                ResultSet rs_igual_final = st.executeQuery(igual_final);
                //ResultSet rs_igual_final = this.ejecutaConsulta(igual_final);
                if (rs_igual_final.next()) {
                    if (rs_igual_final.getInt("TIPO_VACACION_FINAL") < 3) {
                        rs_igual_final.close();
                        rs_igual_final = null;
                        st.close();
                        st = null;
                        return true;
                    } else {
                        rs_igual_final.close();
                        rs_igual_final = null;
                        st.close();
                        st = null;
                        return false;
                    }
                } else {
                    String entre_intervalo = "SELECT COD_DIA_TOMADO, TIPO_VACACION_FINAL FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND '" + TimeFunction.formatearFecha(fecha) + "' BETWEEN FECHA_INICIO_VACACION AND FECHA_FINAL_VACACION";
                    st = this.connection.createStatement();
                    ResultSet rs_entre_intervalo = st.executeQuery(entre_intervalo);
                    //ResultSet rs_entre_intervalo = this.ejecutaConsulta(entre_intervalo);
                    if (rs_entre_intervalo.next()) {
                        rs_entre_intervalo.close();
                        rs_entre_intervalo = null;
                        st.close();
                        st = null;
                        return true;
                    } else {
                        rs_entre_intervalo.close();
                        rs_entre_intervalo = null;
                        st.close();
                        st = null;
                        return false;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean existeSegundoVacacion(int codigo, int division, int sexo, Date fecha) {
        try {
            String igual_inicio = "SELECT COD_DIA_TOMADO, TIPO_VACACION_INICIO, TURNO_INICIO FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND FECHA_INICIO_VACACION= '" + TimeFunction.formatearFecha(fecha) + "'";
            Statement st = this.connection.createStatement();
            ResultSet rs_igual_inicio = st.executeQuery(igual_inicio);

            //ResultSet rs_igual_inicio = this.ejecutaConsulta(igual_inicio);
            if (rs_igual_inicio.next()) {
                if (rs_igual_inicio.getInt("TIPO_VACACION_INICIO") == 1) {
                    rs_igual_inicio.close();
                    rs_igual_inicio = null;
                    st.close();
                    st = null;
                    return true;
                } else {
                    if (rs_igual_inicio.getInt("TURNO_INICIO") == 1) {
                        rs_igual_inicio.close();
                        rs_igual_inicio = null;
                        st.close();
                        st = null;
                        return true;
                    } else {
                        rs_igual_inicio.close();
                        rs_igual_inicio = null;
                        st.close();
                        st = null;
                        return false;
                    }
                }
            } else {
                String igual_final = "SELECT COD_DIA_TOMADO, TIPO_VACACION_FINAL FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND FECHA_FINAL_VACACION= '" + TimeFunction.formatearFecha(fecha) + "'";
                st = this.connection.createStatement();
                ResultSet rs_igual_final = st.executeQuery(igual_final);
                //ResultSet rs_igual_final = this.ejecutaConsulta(igual_final);
                if (rs_igual_final.next()) {
                    if (rs_igual_final.getInt("TIPO_VACACION_FINAL") == 1) {
                        rs_igual_final.close();
                        rs_igual_final = null;
                        st.close();
                        st = null;
                        return true;
                    } else {
                        rs_igual_final.close();
                        rs_igual_final = null;
                        st.close();
                        st = null;
                        return false;
                    }
                } else {
                    String entre_intervalo = "SELECT COD_DIA_TOMADO, TIPO_VACACION_FINAL FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND '" + TimeFunction.formatearFecha(fecha) + "' BETWEEN FECHA_INICIO_VACACION AND FECHA_FINAL_VACACION";
                    st = this.connection.createStatement();
                    ResultSet rs_entre_intervalo = st.executeQuery(entre_intervalo);
                    //ResultSet rs_entre_intervalo = this.ejecutaConsulta(entre_intervalo);
                    if (rs_entre_intervalo.next()) {
                        rs_entre_intervalo.close();
                        rs_entre_intervalo = null;
                        st.close();
                        st = null;
                        return true;
                    } else {
                        rs_entre_intervalo.close();
                        rs_entre_intervalo = null;
                        st.close();
                        st = null;
                        return false;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int existeJornadaPermisoFecha(Personal p, Date fecha) {
        try {
            String query = "SELECT P.TURNO_PERMISO, P.MODALIDAD, T.NOMBRE_TIPO_PERMISO FROM PERSONAL_PERMISOS_TURNO P INNER JOIN TIPOS_PERMISO T ON (P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE COD_PERSONAL=" + p.getCodigo() + " AND TURNO_PERMISO=3 AND FECHA_PERMISO='" + TimeFunction.formatearFecha(fecha) + "'";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                int g = rs.getInt("MODALIDAD");
                rs.close();
                rs = null;
                st.close();
                st = null;
                return g;
            } else {
                query = "SELECT P.COD_PERMISO_DIA, P.COD_TIPO_PERMISO, P.MODALIDAD, T.NOMBRE_TIPO_PERMISO FROM PERSONAL_PERMISOS_DIA P INNER JOIN TIPOS_PERMISO T ON (P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE COD_PERSONAL=" + p.getCodigo() + " AND '" + TimeFunction.formatearFecha(fecha) + "' BETWEEN FECHA_INICIO AND FECHA_FIN";
                st = this.connection.createStatement();
                rs = st.executeQuery(query);
                if (rs.next()) {
                    int gg = rs.getInt("MODALIDAD");
                    rs.close();
                    rs = null;
                    st.close();
                    st = null;
                    return gg;
                } else {
                    rs.close();
                    rs = null;
                    st.close();
                    st = null;
                    return 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int existePrimerPermisoFecha(Personal p, Date fecha) {
        int gg;
        try {
            String query = "SELECT P.TURNO_PERMISO, P.MODALIDAD, T.NOMBRE_TIPO_PERMISO FROM PERSONAL_PERMISOS_TURNO P INNER JOIN TIPOS_PERMISO T ON (P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE COD_PERSONAL=" + p.getCodigo() + " AND ((TURNO_PERMISO=1) OR (TURNO_PERMISO=3)) AND FECHA_PERMISO='" + TimeFunction.formatearFecha(fecha) + "'";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                gg = rs.getInt("MODALIDAD");
            } else {
                query = "SELECT P.COD_PERMISO_DIA, P.COD_TIPO_PERMISO, P.MODALIDAD, T.NOMBRE_TIPO_PERMISO FROM PERSONAL_PERMISOS_DIA P INNER JOIN TIPOS_PERMISO T ON (P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE COD_PERSONAL=" + p.getCodigo() + " AND '" + TimeFunction.formatearFecha(fecha) + "' BETWEEN FECHA_INICIO AND FECHA_FIN";
                rs = this.ejecutaConsulta(query);
                if (rs.next()) {
                    gg = rs.getInt("MODALIDAD");
                } else {
                    gg = 0;
                }
            }
            rs.close();
            rs = null;
            st.close();
            st = null;
            return gg;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int existeSegundoPermisoFecha(Personal p, Date fecha) {
        int gg;
        try {
            String query = "SELECT P.TURNO_PERMISO, P.MODALIDAD, T.NOMBRE_TIPO_PERMISO FROM PERSONAL_PERMISOS_TURNO P INNER JOIN TIPOS_PERMISO T ON (P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE COD_PERSONAL=" + p.getCodigo() + " AND ((TURNO_PERMISO=2) OR (TURNO_PERMISO=3)) AND FECHA_PERMISO='" + TimeFunction.formatearFecha(fecha) + "'";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                gg = rs.getInt("MODALIDAD");
            } else {
                query = "SELECT P.COD_PERMISO_DIA, P.COD_TIPO_PERMISO, P.MODALIDAD, T.NOMBRE_TIPO_PERMISO FROM PERSONAL_PERMISOS_DIA P INNER JOIN TIPOS_PERMISO T ON (P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE COD_PERSONAL=" + p.getCodigo() + " AND '" + TimeFunction.formatearFecha(fecha) + "' BETWEEN FECHA_INICIO AND FECHA_FIN";
                rs = this.ejecutaConsulta(query);
                if (rs.next()) {
                    gg = rs.getInt("MODALIDAD");
                } else {
                    gg = 0;
                }
            }
            rs.close();
            rs = null;
            st.close();
            st = null;
            return gg;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public boolean existePermisoDescuentoDia(int codigo, Date fecha) {
        boolean f;
        try {
            String query = "SELECT P.TURNO_PERMISO, P.MODALIDAD, T.NOMBRE_TIPO_PERMISO FROM PERSONAL_PERMISOS_TURNO P INNER JOIN TIPOS_PERMISO T ON (P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE COD_PERSONAL=" + codigo + " AND ((TURNO_PERMISO=1) OR (TURNO_PERMISO=3)) AND FECHA_PERMISO='" + TimeFunction.formatearFecha(fecha) + "' AND OBS LIKE '%FALTA%'";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                f = true;
            } else {
                query = "SELECT P.COD_PERMISO_DIA, P.COD_TIPO_PERMISO, P.MODALIDAD, T.NOMBRE_TIPO_PERMISO FROM PERSONAL_PERMISOS_DIA P INNER JOIN TIPOS_PERMISO T ON (P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE COD_PERSONAL=" + codigo + " AND '" + TimeFunction.formatearFecha(fecha) + "' BETWEEN FECHA_INICIO AND FECHA_FIN AND OBS LIKE '%FALTA%'";
                rs = this.ejecutaConsulta(query);
                if (rs.next()) {
                    f = true;
                } else {
                    f = false;
                }
            }
            rs.close();
            rs = null;
            st.close();
            st = null;
            return f;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public String buscarNombreArea(int codigo) {
        String nombre = "";
        try {
            String query = "SELECT E.NOMBRE_AREA_EMPRESA FROM AREAS_EMPRESA E WHERE E.COD_AREA_EMPRESA=" + codigo;
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            if (rs.next()) {
                nombre = (rs.getString("NOMBRE_AREA_EMPRESA"));
            } else {
                nombre = null;
            }
            rs.close();
            rs = null;
            st.close();
            st = null;
            return nombre;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
