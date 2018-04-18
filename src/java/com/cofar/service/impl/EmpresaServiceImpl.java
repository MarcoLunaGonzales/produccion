/*
 * EmpresaServiceImpl.java
 *
 * Created on 19 de octubre de 2010, 09:13 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package com.cofar.service.impl;

import com.cofar.bean.Quinquenios;
import com.cofar.bean.aprobacion.AprobacionDominical;
import com.cofar.bean.aprobacion.AprobacionDominicalDetalle;
import com.cofar.bean.aprobacion.AprobacionRefrigerio;
import com.cofar.bean.aprobacion.AprobacionRefrigerioDetalle;
import com.cofar.bean.util.Asistencia;
import com.cofar.bean.util.ControlMarcado;
import com.cofar.bean.util.Marcado;
import com.cofar.bean.util.MarcadoDia;
import com.cofar.bean.util.Personal;
import com.cofar.service.EmpresaService;
import com.cofar.util.TimeFunction;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.model.SelectItem;
import org.joda.time.DateTime;
import com.cofar.util.Util;
import java.sql.Statement;
import java.text.SimpleDateFormat;

/**
 *
 * @author Ismael Juchazara
 */
public class EmpresaServiceImpl extends BaseService implements EmpresaService {

    /** Creates a new instance of EmpresaServiceImpl */
    public EmpresaServiceImpl() {
        super();
    }

    public List listAreasEmpresa() {
        try {
            String query = "SELECT COD_AREA_EMPRESA, NOMBRE_AREA_EMPRESA FROM AREAS_EMPRESA WHERE COD_ESTADO_REGISTRO=1 ORDER BY NOMBRE_AREA_EMPRESA";
            ResultSet resultSet = this.ejecutaConsulta(query);
            ArrayList resultList = new ArrayList();
            while (resultSet.next()) {
                String codigo = resultSet.getString("COD_AREA_EMPRESA");
                String nombre = resultSet.getString("NOMBRE_AREA_EMPRESA");
                resultList.add(new SelectItem("" + resultSet.getString("COD_AREA_EMPRESA"), resultSet.getString("NOMBRE_AREA_EMPRESA")));
            }
            return resultList;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean insertarRegistroControlAsistencia(int cod_p, Date fecha, String ingreso1, String salida1, String ingreso2, String salida2, DateTime e1, DateTime s1, DateTime e2, DateTime s2, int division, int sexo, boolean confianza) {
        try {
            String fecha_temp = "'" + TimeFunction.formatearFecha(fecha) + "'";
            String inserta_control = "INSERT INTO CONTROL_ASISTENCIA VALUES(" + cod_p + ", " + fecha_temp + ", ";
            inserta_control += ingreso1 + ", " + salida1 + ", " + ingreso2 + ", " + salida2 + ", ";
            inserta_control += ingreso1 + ", " + salida1 + ", " + ingreso2 + ", " + salida2 + ", ";
            inserta_control += "0, '', 0, 0)";
            if (cod_p == 1164) {
                System.out.println(inserta_control);
            }
            int rs_inserta_control = this.ejecutaActualizacion(inserta_control);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean generarControlAsistencia(Date inicio, Date fin) {
        try {
            String lista_asistencia = "SELECT DISTINCT(COD_PERSONAL) AS COD_PERSONAL FROM ARCHIVOS_ASISTENCIA_DETALLE WHERE FECHA BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' ORDER BY COD_PERSONAL";
            ResultSet rs_lista_asistencia = this.ejecutaConsulta(lista_asistencia);
            while (rs_lista_asistencia.next()) {
                this.generarControlAsistenciaEmpleado(rs_lista_asistencia.getInt("COD_PERSONAL"), inicio, fin);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean generarControlAsistenciaDivision(int division, Date inicio, Date fin) {
        ResultSet rs_lista_asistencia = null;
        try {
            this.connection = Util.openConnection(connection);
            String lista_asistencia = "SELECT DISTINCT(T.COD_PERSONAL), A.DIVISION FROM ARCHIVOS_ASISTENCIA_DETALLE T INNER JOIN PERSONAL P ON (P.COD_PERSONAL=T.COD_PERSONAL) INNER JOIN AREAS_EMPRESA A ON (P.COD_AREA_EMPRESA=A.COD_AREA_EMPRESA) WHERE T.FECHA BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' AND A.DIVISION=" + division + " ORDER BY T.COD_PERSONAL";
            System.out.println("lista_asistencia:" + lista_asistencia);
            rs_lista_asistencia = this.ejecutaConsulta(lista_asistencia);
            while (rs_lista_asistencia.next()) {
                System.out.println("genera :" + rs_lista_asistencia.getInt("COD_PERSONAL"));
                System.out.println("this.cone INIcio : " + this.connection);
                this.generarControlAsistenciaSimpleEmpleado(rs_lista_asistencia.getInt("COD_PERSONAL"), inicio, fin);
                System.out.println("this.cone FIN : " + this.connection);
                System.gc();
            }
            rs_lista_asistencia.close();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                this.connection.close();
                rs_lista_asistencia.close();
            } catch (SQLException ex) {
                Logger.getLogger(EmpresaServiceImpl.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    public boolean generarDetalleControlAsistenciaDivision(int division, Date inicio, Date fin) {
        ResultSet rs_lista_asistencia = null;
        try {
            SimpleDateFormat f = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
            System.out.println("INICIO:" + f.format(new java.util.Date()));




            this.connection = (Util.openConnection(connection));


            String lista_asistencia = "SELECT DISTINCT (T.COD_PERSONAL), A.DIVISION FROM ARCHIVOS_ASISTENCIA_DETALLE T INNER JOIN PERSONAL P ON (P.COD_PERSONAL=T.COD_PERSONAL) INNER JOIN AREAS_EMPRESA A ON (P.COD_AREA_EMPRESA=A.COD_AREA_EMPRESA) WHERE T.FECHA BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' AND A.DIVISION=" + division + " ORDER BY T.COD_PERSONAL";
            System.out.println(lista_asistencia);
            Statement st = this.connection.createStatement();
            rs_lista_asistencia = st.executeQuery(lista_asistencia);
            List<Integer> listadoPersonal = new ArrayList<Integer>();

            while (rs_lista_asistencia.next()) {
                //this.generarDetalleControlAsistenciaEmpleado(rs_lista_asistencia.getInt("COD_PERSONAL"), inicio, fin);
                listadoPersonal.add(rs_lista_asistencia.getInt("COD_PERSONAL"));

            }


            rs_lista_asistencia.close();
            rs_lista_asistencia = null;
            st.close();
            st = null;

            for (int codPersonal : listadoPersonal) {
                this.generarDetalleControlAsistenciaEmpleado(codPersonal, inicio, fin);

            }
            listadoPersonal.clear();
            listadoPersonal = null;

            System.gc();
            this.connection.close();
            System.out.println("FIN:" + f.format(new java.util.Date()));

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                this.connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(EmpresaServiceImpl.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    public boolean generarControlAsistenciaArea(int codigo, Date inicio, Date fin) {
        ResultSet rs_lista_asistencia = null;
        try {
            String lista_asistencia = "SELECT DISTINCT(T.COD_PERSONAL), A.DIVISION FROM ARCHIVOS_ASISTENCIA_DETALLE T INNER JOIN PERSONAL P ON (P.COD_PERSONAL=T.COD_PERSONAL) INNER JOIN AREAS_EMPRESA A ON (P.COD_AREA_EMPRESA=A.COD_AREA_EMPRESA) WHERE T.FECHA BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' AND A.COD_AREA_EMPRESA=" + codigo + " ORDER BY T.COD_PERSONAL";
            System.out.println("lista_asistencia:" + lista_asistencia);
            rs_lista_asistencia = this.ejecutaConsulta(lista_asistencia);
            while (rs_lista_asistencia.next()) {
                this.generarDetalleControlAsistenciaEmpleado(rs_lista_asistencia.getInt("COD_PERSONAL"), inicio, fin);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                rs_lista_asistencia.close();
            } catch (SQLException ex) {
                Logger.getLogger(EmpresaServiceImpl.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    public boolean generarDetalleControlAsistenciaArea(int codigo, Date inicio, Date fin) {
        try {
            String lista_asistencia = "SELECT DISTINCT(T.COD_PERSONAL), A.DIVISION FROM ARCHIVOS_ASISTENCIA_DETALLE T INNER JOIN PERSONAL P ON (P.COD_PERSONAL=T.COD_PERSONAL) INNER JOIN AREAS_EMPRESA A ON (P.COD_AREA_EMPRESA=A.COD_AREA_EMPRESA) WHERE T.FECHA BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' AND A.COD_AREA_EMPRESA=" + codigo + " ORDER BY T.COD_PERSONAL";
            ResultSet rs_lista_asistencia = this.ejecutaConsulta(lista_asistencia);
            while (rs_lista_asistencia.next()) {
                this.generarDetalleControlAsistenciaEmpleado(rs_lista_asistencia.getInt("COD_PERSONAL"), inicio, fin);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /********w*****/
    public boolean generarControlAsistenciaEmpleado(int codigo, Date inicio, Date fin) {
        try {
            Personal personal = this.buscarPersonal(codigo);
            DateTime entrada1 = null;
            DateTime salida1 = null;
            DateTime entrada2 = null;
            DateTime salida2 = null;
            DateTime primer_dato = null;
            DateTime segundo_dato = null;
            DateTime dia_anterior = new DateTime(inicio).minusDays(1);
            boolean existe_datos = true;
            DateTime ultima_salida = null;
            //comentar para probar la generacion de control de marcado
            String limpiar_tabla = "DELETE FROM CONTROL_ASISTENCIA WHERE FECHA_ASISTENCIA BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' AND COD_PERSONAL=" + codigo;
            int re = this.ejecutaActualizacion(limpiar_tabla);
            String turnos_marcados = "SELECT FECHA, HORA FROM ARCHIVOS_ASISTENCIA_DETALLE WHERE COD_ARCHIVO_DETALLE =";
            turnos_marcados += "(SELECT TOP (1) COD_ARCHIVO_DETALLE FROM ARCHIVOS_ASISTENCIA_DETALLE WHERE COD_PERSONAL=" + codigo + " AND FECHA='" + TimeFunction.formatearFecha(dia_anterior.toDate()) + "' AND COD_ESTADO_REGISTRO=1 ORDER BY HORA DESC)";
            turnos_marcados += " UNION SELECT FECHA, HORA FROM ARCHIVOS_ASISTENCIA_DETALLE WHERE COD_PERSONAL=" + codigo + " AND COD_ESTADO_REGISTRO=1 AND FECHA BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' ORDER BY FECHA ASC, HORA ASC";
            System.out.println("CODIGO PERSONAL: " + codigo);
            ResultSet rs_turnos_marcados = this.ejecutaConsulta(turnos_marcados);
            ResultSet temp_rs_turnos_marcados = this.ejecutaConsulta(turnos_marcados);
            if (temp_rs_turnos_marcados.next()) {
                existe_datos = true;
                while (existe_datos) {
                    int total_insertados = 0;
                    int total_actualizados = 0;
                    boolean primer_reg = true;
                    entrada1 = null;
                    salida1 = null;
                    entrada2 = null;
                    salida2 = null;
                    boolean media_jornada = false;
                    boolean fin_jornada = false;
                    while ((!fin_jornada) && (existe_datos)) {
                        existe_datos = rs_turnos_marcados.next();
                        if (existe_datos) {
                            primer_dato = TimeFunction.convertirDateTime(rs_turnos_marcados.getDate("FECHA"), rs_turnos_marcados.getString("HORA"));
                            existe_datos = rs_turnos_marcados.next();
                            if (existe_datos) {
                                segundo_dato = TimeFunction.convertirDateTime(rs_turnos_marcados.getDate("FECHA"), rs_turnos_marcados.getString("HORA"));
                                while (existe_datos && (TimeFunction.diferenciaTiempo(primer_dato, segundo_dato) < 16)) {
                                    if (segundo_dato != null) {
                                        primer_dato = segundo_dato;
                                    }
                                    existe_datos = rs_turnos_marcados.next();
                                    if (existe_datos) {
                                        segundo_dato = TimeFunction.convertirDateTime(rs_turnos_marcados.getDate("FECHA"), rs_turnos_marcados.getString("HORA"));
                                    }
                                }
                                int intervalo = TimeFunction.calculaIntervalo(primer_dato, segundo_dato, media_jornada, ultima_salida, personal.getDivision(), (personal.getExtras() == 1));
                                switch (intervalo) {
                                    case 1:
                                        entrada1 = primer_dato;
                                        salida1 = segundo_dato;
                                        ultima_salida = salida1;
                                        media_jornada = true;
                                        break;
                                    case 2:
                                        entrada2 = primer_dato;
                                        salida2 = segundo_dato;
                                        ultima_salida = null;
                                        fin_jornada = true;
                                        break;
                                    case 3:
                                        entrada1 = primer_dato;
                                        salida1 = segundo_dato;
                                        ultima_salida = null;
                                        fin_jornada = true;
                                        break;
                                    case 4:
                                        rs_turnos_marcados.previous();
                                        media_jornada = false;
                                        ultima_salida = null;
                                        break;
                                    case 5:
                                        rs_turnos_marcados.previous();
                                        rs_turnos_marcados.previous();
                                        fin_jornada = true;
                                        ultima_salida = null;
                                        media_jornada = false;
                                        break;
                                    case 6:
                                        rs_turnos_marcados.previous();
                                        rs_turnos_marcados.previous();
                                        fin_jornada = true;
                                        ultima_salida = null;
                                        media_jornada = false;
                                        break;
                                    case 7:
                                        rs_turnos_marcados.previous();
                                        rs_turnos_marcados.previous();
                                        fin_jornada = true;
                                        ultima_salida = null;
                                        media_jornada = false;
                                        break;
                                    case 8:
                                        rs_turnos_marcados.previous();
                                        fin_jornada = true;
                                        ultima_salida = null;
                                        media_jornada = false;
                                        break;
                                    default:
                                        rs_turnos_marcados.previous();
                                        break;
                                }
                                if ((entrada1 != null && salida1 != null && entrada2 != null && salida2 != null)) {
                                    if ((entrada1.getDayOfMonth() != entrada2.getDayOfMonth()) || (entrada2.getDayOfMonth() != salida2.getDayOfMonth())) {
                                        DateTime limiteSalida = TimeFunction.convertirDateTime(salida2.toDate(), "03:00");
                                        if (salida2.isAfter(limiteSalida)) {
                                            rs_turnos_marcados.previous();
                                            rs_turnos_marcados.previous();
                                            entrada2 = null;
                                            salida2 = null;
                                        }

                                    }
                                }
                            }
                        }
                    }
                    if ((entrada1 != null) && (entrada2 != null)) {
                        if (entrada2.isBefore(entrada1)) {
                            DateTime temp = entrada1;
                            entrada1 = entrada2;
                            entrada2 = temp;
                            temp = salida1;
                            salida1 = salida2;
                            salida2 = temp;
                        }
                    }
                    if ((entrada1 != null) && (entrada2 == null)) {
                        if ((entrada1.getHourOfDay() > 12) && (entrada1.getDayOfMonth() == salida1.getDayOfMonth())) {
                            entrada2 = entrada1;
                            salida2 = salida1;
                            entrada1 = null;
                            salida1 = null;
                        }
                    }
                    String ing1 = entrada1 != null ? ("'" + TimeFunction.formatearFechaHoraYMD(entrada1.toDate()) + "'") : null;
                    String sal1 = salida1 != null ? ("'" + TimeFunction.formatearFechaHoraYMD(salida1.toDate()) + "'") : null;
                    String ing2 = entrada2 != null ? ("'" + TimeFunction.formatearFechaHoraYMD(entrada2.toDate()) + "'") : null;
                    String sal2 = salida2 != null ? ("'" + TimeFunction.formatearFechaHoraYMD(salida2.toDate()) + "'") : null;
                    Date fecha_registro = null;
                    if (salida1 != null) {
                        if (personal.getDivision() == 3) {
                            fecha_registro = salida1.toDate();
                        } else {
                            fecha_registro = entrada1.toDate();
                        }

                    } else if (salida2 != null) {
                        if (personal.getDivision() == 3) {
                            fecha_registro = salida2.toDate();
                        } else {
                            fecha_registro = entrada2.toDate();
                        }
                    }
                    if (fecha_registro != null) {
                        if ((ing1 != null) || (ing2 != null)) {
                            if ((entrada1 != null) && (entrada2 != null)) {
                                if (entrada1.getDayOfMonth() != entrada2.getDayOfMonth()) {
                                    if (this.insertarRegistroControlAsistencia(codigo, fecha_registro, ing1, sal1, null, null, entrada1, salida1, entrada2, salida2, personal.getDivision(), personal.getSexo(), personal.isConfianza())) {
                                        total_insertados++;
                                    }
                                    if (this.insertarRegistroControlAsistencia(codigo, entrada2.toDate(), null, null, ing2, sal2, entrada1, salida1, entrada2, salida2, personal.getDivision(), personal.getSexo(), personal.isConfianza())) {
                                        total_insertados++;
                                    }
                                } else {
                                    if (this.insertarRegistroControlAsistencia(codigo, fecha_registro, ing1, sal1, ing2, sal2, entrada1, salida1, entrada2, salida2, personal.getDivision(), personal.getSexo(), personal.isConfianza())) {
                                        total_insertados++;
                                    }
                                }
                            } else {
                                if (this.insertarRegistroControlAsistencia(codigo, fecha_registro, ing1, sal1, ing2, sal2, entrada1, salida1, entrada2, salida2, personal.getDivision(), personal.getSexo(), personal.isConfianza())) {
                                    total_insertados++;
                                }
                            }
                        }
                    }
                }
            }
            //* AGREGAR CALCULO DE PLANILLA
            Personal temp_personal = this.listaAsistenciaEmpleadoIndividual(codigo, inicio, fin);
            if (temp_personal != null) {
                DateTime inicioContrato = this.fechaInicioContrato(codigo).minusDays(1);
                DateTime finContrato = this.fechaConclusionContrato(codigo);
                finContrato = finContrato.plusDays(1);
                if (temp_personal.getAsistencia() != null) {
                    for (Asistencia a : temp_personal.getAsistencia()) {
                        String limpiar_tabla2 = "DELETE FROM CONTROL_ASISTENCIA_DETALLE WHERE FECHA='" + TimeFunction.formatearFecha(a.getFecha()) + "' AND COD_PERSONAL=" + codigo;
                        int res = this.ejecutaActualizacion(limpiar_tabla2);

                        DateTime temp_fecha = new DateTime(a.getFecha());
                        if (temp_fecha.isAfter(inicioContrato) && temp_fecha.isBefore(finContrato)) {
                            String ing1 = a.getPrimerIngresoTime() != null ? ("'" + TimeFunction.formatearFechaHoraYMD(a.getPrimerIngresoTime().toDate()) + "'") : null;
                            String sal1 = a.getPrimerSalidaTime() != null ? ("'" + TimeFunction.formatearFechaHoraYMD(a.getPrimerSalidaTime().toDate()) + "'") : null;
                            String ing2 = a.getSegundoIngresoTime() != null ? ("'" + TimeFunction.formatearFechaHoraYMD(a.getSegundoIngresoTime().toDate()) + "'") : null;
                            String sal2 = a.getSegundoSalidaTime() != null ? ("'" + TimeFunction.formatearFechaHoraYMD(a.getSegundoSalidaTime().toDate()) + "'") : null;
                            int minutosDescuento = 0;
                            if (this.isDiaLaboral(a.getFecha(), temp_personal.getDivision(), temp_personal.getSexo(), codigo)) {
                                minutosDescuento = this.totalMinutosDescuentoDia(codigo, temp_personal.getDivision(), temp_personal.getSexo(), a.getFecha());
                            }
                            String inserta_respaldo = "INSERT INTO CONTROL_ASISTENCIA_DETALLE VALUES(" + codigo + ", '" + TimeFunction.formatearFecha(a.getFecha()) + "', ";
                            inserta_respaldo += ing1 + ", " + sal1 + ", " + ing2 + ", " + sal2 + ", ";
                            inserta_respaldo += a.getMinutosTrabajado() + ", " + a.getMinutosLaboral() + ", " + a.getMinutosComputable() + ", " + a.getMinutosPrimerNocturno() + ", ";
                            inserta_respaldo += a.getMinutosSegundoNocturno() + ", " + a.getTotalMinutosExcedente() + ", " + a.totalMinutosFaltante() + ", " + minutosDescuento + ")";
                            if (codigo == 1164) {
                                System.out.println(inserta_respaldo);
                            }
                            int rs_inserta_respaldo = this.ejecutaActualizacion(inserta_respaldo);
                        }
                    }
                }
            }

            /* FIN AGREGAR CALCULO DE PLANILLA */
            System.gc();
            return true;
        } catch (Exception e) {
            System.gc();
            e.printStackTrace();
            return false;
        }
    }
////w//

    public boolean generarControlAsistenciaSimpleEmpleado(int codigo, Date inicio, Date fin) {
        ResultSet rs_turnos_marcados = null;
        ResultSet temp_rs_turnos_marcados = null;
        try {
            this.connection = Util.openConnection(connection);
            Personal personal = this.buscarPersonal(codigo);
            DateTime entrada1 = null;
            DateTime salida1 = null;
            DateTime entrada2 = null;
            DateTime salida2 = null;
            DateTime primer_dato = null;
            DateTime segundo_dato = null;
            DateTime dia_anterior = new DateTime(inicio).minusDays(1);
            boolean existe_datos = true;
            DateTime ultima_salida = null;
            //comentar para probar la generacion de control de marcado

            String limpiar_tabla = "DELETE FROM CONTROL_ASISTENCIA WHERE FECHA_ASISTENCIA BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' AND COD_PERSONAL=" + codigo;
            int re = this.ejecutaActualizacion(limpiar_tabla);
            String turnos_marcados = "SELECT FECHA, HORA FROM ARCHIVOS_ASISTENCIA_DETALLE WHERE COD_ARCHIVO_DETALLE =";
            turnos_marcados += "(SELECT TOP (1) COD_ARCHIVO_DETALLE FROM ARCHIVOS_ASISTENCIA_DETALLE WHERE COD_PERSONAL=" + codigo + " AND FECHA='" + TimeFunction.formatearFecha(dia_anterior.toDate()) + "' AND COD_ESTADO_REGISTRO=1 ORDER BY HORA DESC)";
            turnos_marcados += " UNION SELECT FECHA, HORA FROM ARCHIVOS_ASISTENCIA_DETALLE WHERE COD_PERSONAL=" + codigo + " AND COD_ESTADO_REGISTRO=1 AND FECHA BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' ORDER BY FECHA ASC, HORA ASC";
            System.out.println("turnos marcados:" + turnos_marcados);
            System.out.println("CODIGO PERSONAL: " + codigo);
            rs_turnos_marcados = this.ejecutaConsulta(turnos_marcados);

            temp_rs_turnos_marcados = this.ejecutaConsulta(turnos_marcados);
            if (temp_rs_turnos_marcados.next()) {
                existe_datos = true;
                while (existe_datos) {
                    int total_insertados = 0;
                    int total_actualizados = 0;
                    boolean primer_reg = true;
                    entrada1 = null;
                    salida1 = null;
                    entrada2 = null;
                    salida2 = null;
                    boolean media_jornada = false;
                    boolean fin_jornada = false;
                    while ((!fin_jornada) && (existe_datos)) {
                        existe_datos = rs_turnos_marcados.next();
                        if (existe_datos) {
                            primer_dato = TimeFunction.convertirDateTime(rs_turnos_marcados.getDate("FECHA"), rs_turnos_marcados.getString("HORA"));
                            existe_datos = rs_turnos_marcados.next();
                            if (existe_datos) {
                                segundo_dato = TimeFunction.convertirDateTime(rs_turnos_marcados.getDate("FECHA"), rs_turnos_marcados.getString("HORA"));
                                while (existe_datos && (TimeFunction.diferenciaTiempo(primer_dato, segundo_dato) < 16)) {
                                    if (segundo_dato != null) {
                                        primer_dato = segundo_dato;
                                    }
                                    existe_datos = rs_turnos_marcados.next();
                                    if (existe_datos) {
                                        segundo_dato = TimeFunction.convertirDateTime(rs_turnos_marcados.getDate("FECHA"), rs_turnos_marcados.getString("HORA"));
                                    }
                                }
                                int intervalo = TimeFunction.calculaIntervalo(primer_dato, segundo_dato, media_jornada, ultima_salida, personal.getDivision(), (personal.getExtras() == 1));
                                switch (intervalo) {
                                    case 1:
                                        entrada1 = primer_dato;
                                        salida1 = segundo_dato;
                                        ultima_salida = salida1;
                                        media_jornada = true;
                                        break;
                                    case 2:
                                        entrada2 = primer_dato;
                                        salida2 = segundo_dato;
                                        ultima_salida = null;
                                        fin_jornada = true;
                                        break;
                                    case 3:
                                        entrada1 = primer_dato;
                                        salida1 = segundo_dato;
                                        ultima_salida = null;
                                        fin_jornada = true;
                                        break;
                                    case 4:
                                        rs_turnos_marcados.previous();
                                        media_jornada = false;
                                        ultima_salida = null;
                                        break;
                                    case 5:
                                        rs_turnos_marcados.previous();
                                        rs_turnos_marcados.previous();
                                        fin_jornada = true;
                                        ultima_salida = null;
                                        media_jornada = false;
                                        break;
                                    case 6:
                                        rs_turnos_marcados.previous();
                                        rs_turnos_marcados.previous();
                                        fin_jornada = true;
                                        ultima_salida = null;
                                        media_jornada = false;
                                        break;
                                    case 7:
                                        rs_turnos_marcados.previous();
                                        rs_turnos_marcados.previous();
                                        fin_jornada = true;
                                        ultima_salida = null;
                                        media_jornada = false;
                                        break;
                                    case 8:
                                        rs_turnos_marcados.previous();
                                        fin_jornada = true;
                                        ultima_salida = null;
                                        media_jornada = false;
                                        break;
                                    default:
                                        rs_turnos_marcados.previous();
                                        break;
                                }
                                if ((entrada1 != null && salida1 != null && entrada2 != null && salida2 != null)) {
                                    if ((entrada1.getDayOfMonth() != entrada2.getDayOfMonth()) || (entrada2.getDayOfMonth() != salida2.getDayOfMonth())) {
                                        DateTime limiteSalida = TimeFunction.convertirDateTime(salida2.toDate(), "03:00");
                                        if (salida2.isAfter(limiteSalida)) {
                                            rs_turnos_marcados.previous();
                                            rs_turnos_marcados.previous();
                                            entrada2 = null;
                                            salida2 = null;
                                        }

                                    }
                                }
                            }
                        }
                    }
                    if ((entrada1 != null) && (entrada2 != null)) {
                        if (entrada2.isBefore(entrada1)) {
                            DateTime temp = entrada1;
                            entrada1 = entrada2;
                            entrada2 = temp;
                            temp = salida1;
                            salida1 = salida2;
                            salida2 = temp;
                        }
                    }
                    if ((entrada1 != null) && (entrada2 == null)) {
                        if ((entrada1.getHourOfDay() > 12) && (entrada1.getDayOfMonth() == salida1.getDayOfMonth())) {
                            entrada2 = entrada1;
                            salida2 = salida1;
                            entrada1 = null;
                            salida1 = null;
                        }
                    }
                    String ing1 = entrada1 != null ? ("'" + TimeFunction.formatearFechaHoraYMD(entrada1.toDate()) + "'") : null;
                    String sal1 = salida1 != null ? ("'" + TimeFunction.formatearFechaHoraYMD(salida1.toDate()) + "'") : null;
                    String ing2 = entrada2 != null ? ("'" + TimeFunction.formatearFechaHoraYMD(entrada2.toDate()) + "'") : null;
                    String sal2 = salida2 != null ? ("'" + TimeFunction.formatearFechaHoraYMD(salida2.toDate()) + "'") : null;
                    Date fecha_registro = null;
                    if (salida1 != null) {
                        if (personal.getDivision() == 3) {
                            fecha_registro = salida1.toDate();
                        } else {
                            fecha_registro = entrada1.toDate();
                        }

                    } else if (salida2 != null) {
                        if (personal.getDivision() == 3) {
                            fecha_registro = salida2.toDate();
                        } else {
                            fecha_registro = entrada2.toDate();
                        }
                    }
                    if (fecha_registro != null) {
                        if ((ing1 != null) || (ing2 != null)) {
                            if ((entrada1 != null) && (entrada2 != null)) {
                                if (entrada1.getDayOfMonth() != entrada2.getDayOfMonth()) {
                                    if (this.insertarRegistroControlAsistencia(codigo, fecha_registro, ing1, sal1, null, null, entrada1, salida1, entrada2, salida2, personal.getDivision(), personal.getSexo(), personal.isConfianza())) {
                                        total_insertados++;
                                    }
                                    if (this.insertarRegistroControlAsistencia(codigo, entrada2.toDate(), null, null, ing2, sal2, entrada1, salida1, entrada2, salida2, personal.getDivision(), personal.getSexo(), personal.isConfianza())) {
                                        total_insertados++;
                                    }
                                } else {
                                    if (this.insertarRegistroControlAsistencia(codigo, fecha_registro, ing1, sal1, ing2, sal2, entrada1, salida1, entrada2, salida2, personal.getDivision(), personal.getSexo(), personal.isConfianza())) {
                                        total_insertados++;
                                    }
                                }
                            } else {
                                if (this.insertarRegistroControlAsistencia(codigo, fecha_registro, ing1, sal1, ing2, sal2, entrada1, salida1, entrada2, salida2, personal.getDivision(), personal.getSexo(), personal.isConfianza())) {
                                    total_insertados++;
                                }
                            }
                        }
                    }
                }
            }
            /* AGREGAR CALCULO DE PLANILLA
            Personal temp_personal = this.listaAsistenciaEmpleadoIndividual(codigo, inicio, fin);
            if(temp_personal!=null){
            DateTime inicioContrato = this.fechaInicioContrato(codigo).minusDays(1);
            DateTime finContrato = this.fechaConclusionContrato(codigo);
            finContrato= finContrato.plusDays(1);
            if(temp_personal.getAsistencia()!=null){
            for(Asistencia a: temp_personal.getAsistencia()){
            String limpiar_tabla2 = "DELETE FROM CONTROL_ASISTENCIA_DETALLE WHERE FECHA='" + TimeFunction.formatearFecha(a.getFecha()) +  "' AND COD_PERSONAL=" + codigo;
            int res = this.ejecutaActualizacion(limpiar_tabla2);

            DateTime temp_fecha = new DateTime(a.getFecha());
            if(temp_fecha.isAfter(inicioContrato) && temp_fecha.isBefore(finContrato)){
            String ing1 = a.getPrimerIngresoTime()!=null? ("'" + TimeFunction.formatearFechaHoraYMD(a.getPrimerIngresoTime().toDate()) + "'"):null;
            String sal1 = a.getPrimerSalidaTime()!=null? ("'" + TimeFunction.formatearFechaHoraYMD(a.getPrimerSalidaTime().toDate()) + "'"):null;
            String ing2 = a.getSegundoIngresoTime()!=null? ("'" + TimeFunction.formatearFechaHoraYMD(a.getSegundoIngresoTime().toDate()) + "'"):null;
            String sal2 = a.getSegundoSalidaTime()!=null? ("'" + TimeFunction.formatearFechaHoraYMD(a.getSegundoSalidaTime().toDate()) + "'"):null;
            int minutosDescuento = 0;
            if(this.isDiaLaboral(a.getFecha(), temp_personal.getDivision(), temp_personal.getSexo(), codigo)){
            minutosDescuento = this.totalMinutosDescuentoDia(codigo, temp_personal.getDivision(), temp_personal.getSexo(), a.getFecha());
            }
            String inserta_respaldo = "INSERT INTO CONTROL_ASISTENCIA_DETALLE VALUES(" + codigo + ", '" + TimeFunction.formatearFecha(a.getFecha()) + "', ";
            inserta_respaldo += ing1 + ", " + sal1 + ", " + ing2 + ", " + sal2 + ", ";
            inserta_respaldo += a.getMinutosTrabajado() + ", " + a.getMinutosLaboral() + ", " + a.getMinutosComputable() + ", " + a.getMinutosPrimerNocturno() + ", ";
            inserta_respaldo += a.getMinutosSegundoNocturno() + ", " + a.getTotalMinutosExcedente() + ", " + a.totalMinutosFaltante() + ", " + minutosDescuento + ")";
            int rs_inserta_respaldo= this.ejecutaActualizacion(inserta_respaldo);
            }
            }
            }
            }*/

            /* FIN AGREGAR CALCULO DE PLANILLA */
            System.gc();
            return true;
        } catch (SQLException e) {
            System.gc();
            e.printStackTrace();
            return false;
        } finally {
            try {
                //this.connection.close();
                temp_rs_turnos_marcados.close();
                rs_turnos_marcados.close();
            } catch (SQLException ex) {
                Logger.getLogger(EmpresaServiceImpl.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
//asistencia detalle

    public void generarDetalleControlAsistenciaEmpleado(int codigo, Date inicio, Date fin) {
        Personal personal = this.listaAsistenciaEmpleadoIndividual(codigo, inicio, fin);
        DateTime fecha_inicio = new DateTime(inicio);
        DateTime fecha_fin = new DateTime(fin);
        System.out.println("CODIGO: " + codigo);
        if (personal != null) {
            DateTime inicioContrato = this.fechaInicioContrato(codigo).minusDays(1);
            DateTime finContrato = this.fechaConclusionContrato(codigo);
            finContrato = finContrato.plusDays(1);
            if (personal.getAsistencia() != null) {
                String limpiar_tabla2 = "DELETE FROM CONTROL_ASISTENCIA_DETALLE WHERE FECHA>'" + TimeFunction.formatearFecha(fecha_inicio.minusDays(1).toDate()) + "' AND FECHA<'" + TimeFunction.formatearFecha(fecha_fin.plusDays(1).toDate()) + "' AND COD_PERSONAL=" + codigo;
                System.out.println(limpiar_tabla2);
                int res = this.ejecutaActualizacion(limpiar_tabla2);
                for (Asistencia a : personal.getAsistencia()) {
                    DateTime temp_fecha = new DateTime(a.getFecha());
                    if (temp_fecha.isAfter(inicioContrato) && temp_fecha.isBefore(finContrato)) {
                        String ing1 = a.getPrimerIngresoTime() != null ? ("'" + TimeFunction.formatearFechaHoraYMD(a.getPrimerIngresoTime().toDate()) + "'") : null;
                        String sal1 = a.getPrimerSalidaTime() != null ? ("'" + TimeFunction.formatearFechaHoraYMD(a.getPrimerSalidaTime().toDate()) + "'") : null;
                        String ing2 = a.getSegundoIngresoTime() != null ? ("'" + TimeFunction.formatearFechaHoraYMD(a.getSegundoIngresoTime().toDate()) + "'") : null;
                        String sal2 = a.getSegundoSalidaTime() != null ? ("'" + TimeFunction.formatearFechaHoraYMD(a.getSegundoSalidaTime().toDate()) + "'") : null;
                        int minutosDescuento = 0;
                        if (this.isDiaLaboral(a.getFecha(), personal.getDivision(), personal.getSexo(), codigo)) {
                            minutosDescuento = this.totalMinutosDescuentoDia(codigo, personal.getDivision(), personal.getSexo(), a.getFecha());
                        }
                        String inserta_respaldo = "INSERT INTO CONTROL_ASISTENCIA_DETALLE VALUES(" + codigo + ", '" + TimeFunction.formatearFecha(a.getFecha()) + "', ";
                        System.out.println("inserta_respaldo:" + inserta_respaldo);
                        inserta_respaldo += ing1 + ", " + sal1 + ", " + ing2 + ", " + sal2 + ", ";
                        inserta_respaldo += a.getMinutosTrabajado() + ", " + a.getMinutosLaboral() + ", " + a.getMinutosComputable() + ", " + a.getMinutosPrimerNocturno() + ", ";
                        inserta_respaldo += a.getMinutosSegundoNocturno() + ", " + a.getTotalMinutosExcedente() + ", " + a.totalMinutosFaltante() + ", " + minutosDescuento + ")";
                        System.out.println(inserta_respaldo);
                        int rs_inserta_respaldo = this.ejecutaActualizacion(inserta_respaldo);

                    }
                }
            }
        }
    }

    public List generarListaMarcados(int codigo, Date inicio, Date fin) {
        try {
            List resultList = new ArrayList();
            String lista_marcados = "SELECT A.COD_ARCHIVO_DETALLE, A.FECHA, A.HORA, A.COD_ESTADO_REGISTRO FROM ARCHIVOS_ASISTENCIA_DETALLE A WHERE A.COD_PERSONAL=" + codigo + " AND A.FECHA BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' ORDER BY A.FECHA ASC, A.HORA ASC";
            Statement st = this.connection.createStatement();
            ResultSet rs_lista_marcados = st.executeQuery(lista_marcados);
            //ResultSet rs_lista_marcados = this.ejecutaConsulta(lista_marcados);
            while (rs_lista_marcados.next()) {
                resultList.add(new Marcado(rs_lista_marcados.getInt("COD_ARCHIVO_DETALLE"), rs_lista_marcados.getDate("FECHA"), rs_lista_marcados.getString("HORA"), rs_lista_marcados.getInt("COD_ESTADO_REGISTRO")));
            }

            st.close();
            st = null;
            rs_lista_marcados.close();
            rs_lista_marcados = null;
            return resultList;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList();
        }
    }

    public List<MarcadoDia> generarListaMarcadosVacio(int codigo, Date inicio, Date fin) {
        try {
            List resultList = new ArrayList();
            DateTime inicioIntervalo = new DateTime(inicio);
            DateTime finIntervalo = new DateTime(fin).plusDays(1);
            List<MarcadoDia> resultado = new ArrayList();
            while (inicioIntervalo.isBefore(finIntervalo)) {
                resultList.add(new MarcadoDia(codigo, inicioIntervalo.toDate()));
                inicioIntervalo = inicioIntervalo.plusDays(1);
            }
            return resultList;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<ControlMarcado> generarListaControlMarcado(int codigo, Date inicio, Date fin) {
        try {
            DateTime inicioIntervalo = new DateTime(inicio);
            DateTime finIntervalo = new DateTime(fin).plusDays(1);
            List<ControlMarcado> resultado = new ArrayList();
            while (inicioIntervalo.isBefore(finIntervalo)) {
                String lista_marcados = "SELECT A.COD_ARCHIVO_DETALLE, A.FECHA, A.HORA, A.COD_ESTADO_REGISTRO FROM ARCHIVOS_ASISTENCIA_DETALLE A WHERE A.COD_PERSONAL=" + codigo + " AND A.FECHA='" + TimeFunction.formatearFecha(inicioIntervalo.toDate()) + "' ORDER BY A.FECHA ASC, A.HORA ASC";
                Statement st = this.connection.createStatement();
                ResultSet rs_lista_marcados = st.executeQuery(lista_marcados);
                //ResultSet rs_lista_marcados = this.ejecutaConsulta(lista_marcados);
                int p = 1;
                ControlMarcado control = new ControlMarcado(inicioIntervalo.toDate());
                while (rs_lista_marcados.next()) {
                    switch (p) {
                        case 1:
                            control.setPrimero(new Marcado(rs_lista_marcados.getInt("COD_ARCHIVO_DETALLE"), rs_lista_marcados.getDate("FECHA"), rs_lista_marcados.getString("HORA"), rs_lista_marcados.getInt("COD_ESTADO_REGISTRO")));
                            break;
                        case 2:
                            control.setSegundo(new Marcado(rs_lista_marcados.getInt("COD_ARCHIVO_DETALLE"), rs_lista_marcados.getDate("FECHA"), rs_lista_marcados.getString("HORA"), rs_lista_marcados.getInt("COD_ESTADO_REGISTRO")));
                            break;
                        case 3:
                            control.setTercero(new Marcado(rs_lista_marcados.getInt("COD_ARCHIVO_DETALLE"), rs_lista_marcados.getDate("FECHA"), rs_lista_marcados.getString("HORA"), rs_lista_marcados.getInt("COD_ESTADO_REGISTRO")));
                            break;
                        case 4:
                            control.setCuarto(new Marcado(rs_lista_marcados.getInt("COD_ARCHIVO_DETALLE"), rs_lista_marcados.getDate("FECHA"), rs_lista_marcados.getString("HORA"), rs_lista_marcados.getInt("COD_ESTADO_REGISTRO")));
                            break;
                        case 5:
                            control.setQuinto(new Marcado(rs_lista_marcados.getInt("COD_ARCHIVO_DETALLE"), rs_lista_marcados.getDate("FECHA"), rs_lista_marcados.getString("HORA"), rs_lista_marcados.getInt("COD_ESTADO_REGISTRO")));
                            break;
                        case 6:
                            control.setSexto(new Marcado(rs_lista_marcados.getInt("COD_ARCHIVO_DETALLE"), rs_lista_marcados.getDate("FECHA"), rs_lista_marcados.getString("HORA"), rs_lista_marcados.getInt("COD_ESTADO_REGISTRO")));
                            break;
                        default:
                            break;
                    }
                    p++;
                }
                resultado.add(control);
                inicioIntervalo = inicioIntervalo.plusDays(1);
                st.close();
            st = null;
            rs_lista_marcados.close();
            rs_lista_marcados = null;
            }

            return resultado;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean cambiarEstadoMarcado(int codigo) {
        try {
            String tipo_estado = "SELECT COD_ESTADO_REGISTRO FROM ARCHIVOS_ASISTENCIA_DETALLE WHERE COD_ARCHIVO_DETALLE=" + codigo;
            ResultSet rs_tipo_estado = this.ejecutaConsulta(tipo_estado);
            if (rs_tipo_estado.next()) {
                int tipo = rs_tipo_estado.getInt("COD_ESTADO_REGISTRO");
                String cod_estado = "0";
                if (tipo == 0) {
                    cod_estado = "1";
                }
                String cambiar_estado = "UPDATE ARCHIVOS_ASISTENCIA_DETALLE SET COD_ESTADO_REGISTRO=" + cod_estado + " WHERE COD_ARCHIVO_DETALLE=" + codigo;
                int r = this.ejecutaActualizacion(cambiar_estado);

                return true;

            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarMarcado(int codigo) {
        try {
            String eliminar_marcado = "DELETE FROM ARCHIVOS_ASISTENCIA_DETALLE WHERE COD_ARCHIVO_DETALLE=" + codigo;
            int r = this.ejecutaActualizacion(eliminar_marcado);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Personal buscarPersonal(int codigo) {
        try {
            Personal empleado = null;
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + P.NOMBRES_PERSONAL+' '+P.nombre2_personal AS NOMBRE_COMPLETO,";
            query += " C.DESCRIPCION_CARGO, P.SEXO_PERSONAL, P.RECIBE_EXTRAS, P.CONFIANZA, P.CONTROL_ASISTENCIA, AE.NOMBRE_AREA_EMPRESA, AE.DIVISION FROM PERSONAL P INNER JOIN CARGOS C ON (P.CODIGO_CARGO=C.CODIGO_CARGO) ";
            query += "INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) WHERE P.COD_ESTADO_PERSONA<3 AND P.COD_PERSONAL=" + codigo;
            ResultSet resultSet = ejecutaConsulta(query);
            if (resultSet.next()) {
                empleado = new Personal(resultSet.getInt("COD_PERSONAL"), resultSet.getString("NOMBRE_COMPLETO"), resultSet.getString("DESCRIPCION_CARGO"), resultSet.getInt("SEXO_PERSONAL"), resultSet.getString("NOMBRE_AREA_EMPRESA"), resultSet.getInt("DIVISION"), resultSet.getInt("RECIBE_EXTRAS"), (resultSet.getInt("CONFIANZA") == 1 ? true : false), (resultSet.getInt("CONTROL_ASISTENCIA") == 1 ? true : false));
            }
            resultSet.close();
            return empleado;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean registrarPermisoFecha(int codigo_personal, Date fecha, int tipo_permiso, String hora_inicio, String hora_fin, String observacion, int modalidad, int numero_boleta) {
        try {
            String codigo_permiso = "SELECT (MAX(COD_PERMISO) + 1) AS NUEVO_CODIGO FROM PERSONAL_PERMISOS";
            ResultSet rs_codigo_permiso = this.ejecutaConsulta(codigo_permiso);
            String cod_permiso = null;
            if (rs_codigo_permiso.next()) {
                cod_permiso = rs_codigo_permiso.getString("NUEVO_CODIGO");
                if (cod_permiso == null) {
                    cod_permiso = "1";
                }
            }
            if (hora_inicio.length() < 5) {
                hora_inicio = "0" + hora_inicio;
            }
            if (hora_fin.length() < 5) {
                hora_fin = "0" + hora_fin;
            }
            String verifica_registro = "SELECT COD_PERMISO FROM PERSONAL_PERMISOS WHERE COD_PERSONAL=" + codigo_personal + " AND FECHA_PERMISO='" + TimeFunction.formatearFecha(fecha) + "' AND HORA_INICIO='" + hora_inicio + "'";
            ResultSet rs_verifica_registro = this.ejecutaConsulta(verifica_registro);
            if (!rs_verifica_registro.next()) {
                String inserta_registro = "INSERT INTO PERSONAL_PERMISOS VALUES(" + cod_permiso + "," + codigo_personal + ", '" + TimeFunction.formatearFecha(fecha) + "', " + tipo_permiso + ", '" + hora_inicio + "', '" + hora_fin + "', '" + observacion + "', " + modalidad + ", " + numero_boleta + ", 1)";
                int r = this.ejecutaActualizacion(inserta_registro);
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean registrarPermisoTurno(int codigo_personal, Date fecha, int tipo_permiso, int tipo_turno, String observacion, int modalidad, int numero_boleta) {
        try {
            String codigo_permiso = "SELECT (MAX(COD_PERMISO_TURNO) + 1) AS NUEVO_CODIGO FROM PERSONAL_PERMISOS_TURNO";
            ResultSet rs_codigo_permiso = this.ejecutaConsulta(codigo_permiso);
            String cod_permiso = null;
            if (rs_codigo_permiso.next()) {
                cod_permiso = rs_codigo_permiso.getString("NUEVO_CODIGO");
                if (cod_permiso == null) {
                    cod_permiso = "1";
                }
            }
            String verifica_registro = "SELECT COD_PERMISO_TURNO FROM PERSONAL_PERMISOS_TURNO WHERE COD_PERSONAL=" + codigo_personal + " AND FECHA_PERMISO='" + TimeFunction.formatearFecha(fecha) + "' AND TURNO_PERMISO=" + tipo_turno;
            ResultSet rs_verifica_registro = this.ejecutaConsulta(verifica_registro);
            if (!rs_verifica_registro.next()) {
                String inserta_registro = "INSERT INTO PERSONAL_PERMISOS_TURNO VALUES(" + cod_permiso + "," + codigo_personal + ", '" + TimeFunction.formatearFecha(fecha) + "', " + tipo_permiso + ", " + tipo_turno + ", " + modalidad + ", '" + observacion + "', " + numero_boleta + ", 1)";
                int r = this.ejecutaActualizacion(inserta_registro);
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean registrarPermisoPeriodo(int codigo, Date inicio, Date fin, String observacion, int tipo, int modalidad, int numero_boleta) {
        try {
            String codigo_permiso = "SELECT (MAX(COD_PERMISO_DIA) + 1) AS NUEVO_CODIGO FROM PERSONAL_PERMISOS_DIA";
            ResultSet rs_codigo_permiso = this.ejecutaConsulta(codigo_permiso);
            String cod_permiso = null;
            if (rs_codigo_permiso.next()) {
                cod_permiso = rs_codigo_permiso.getString("NUEVO_CODIGO");
                if (cod_permiso == null) {
                    cod_permiso = "1";
                }
            }
            String verifica_registro = "SELECT COD_PERMISO_DIA FROM PERSONAL_PERMISOS_DIA WHERE COD_PERSONAL=" + codigo + " AND FECHA_INICIO='" + TimeFunction.formatearFecha(inicio) + "' AND FECHA_FIN='" + TimeFunction.formatearFecha(fin) + "'";
            ResultSet rs_verifica_registro = this.ejecutaConsulta(verifica_registro);
            if (!rs_verifica_registro.next()) {
                String inserta_registro = "INSERT INTO PERSONAL_PERMISOS_DIA VALUES(" + cod_permiso + "," + codigo + ", '" + TimeFunction.formatearFecha(inicio) + "', '" + TimeFunction.formatearFecha(fin) + "', " + tipo + ", " + modalidad + ", '" + observacion + "', " + numero_boleta + ", 1)";
                int r = this.ejecutaActualizacion(inserta_registro);
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public String buscarArea(int codigo) {
        String resultado = null;
        try {
            String query = "SELECT NOMBRE_AREA_EMPRESA FROM AREAS_EMPRESA WHERE COD_AREA_EMPRESA=" + codigo;
            ResultSet resultSet = ejecutaConsulta(query);
            if (resultSet.next()) {
                resultado = resultSet.getString("NOMBRE_AREA_EMPRESA");
            }
            return resultado;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Date buscarFechaMarcado(int codigo) {
        Date resultado = null;
        try {
            String query = "SELECT FECHA FROM ARCHIVOS_ASISTENCIA_DETALLE WHERE COD_ARCHIVO_DETALLE=" + codigo;
            ResultSet resultSet = ejecutaConsulta(query);
            if (resultSet.next()) {
                resultado = resultSet.getDate("FECHA");
            }
            return resultado;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean agregarMarcado(int codigo, Date fecha, String hora) {
        try {
            int cod_archivo_detalle = 1;
            String codigo_archivo = "SELECT (MAX(COD_ARCHIVO_DETALLE) + 1) AS NUEVO_CODIGO FROM ARCHIVOS_ASISTENCIA_DETALLE";
            ResultSet rs_codigo_archivo = this.ejecutaConsulta(codigo_archivo);
            String temp_hora = hora.replace('.', ':');
            temp_hora = temp_hora.replace(',', ':');
            temp_hora = temp_hora.replace(';', ':');
            temp_hora = temp_hora.replace('_', ':');
            temp_hora = temp_hora.replace('-', ':');
            if (rs_codigo_archivo.next()) {
                cod_archivo_detalle = rs_codigo_archivo.getInt("NUEVO_CODIGO");
            }
            String verifica_registro = "SELECT COD_ARCHIVO_DETALLE FROM ARCHIVOS_ASISTENCIA_DETALLE WHERE COD_PERSONAL=" + codigo + " AND FECHA='" + TimeFunction.formatearFecha(fecha) + "' AND HORA='" + temp_hora + "'";
            ResultSet rs_verifica_registro = this.ejecutaConsulta(verifica_registro);
            if (!rs_verifica_registro.next()) {
                if (temp_hora.length() < 5) {
                    temp_hora = "0" + temp_hora;
                }
                String inserta_registro = "INSERT INTO ARCHIVOS_ASISTENCIA_DETALLE VALUES(" + cod_archivo_detalle + ", 0 , " + codigo + ", '" + TimeFunction.formatearFecha(fecha) + "', '" + temp_hora + "', 1)";
                int resultado = this.ejecutaActualizacion(inserta_registro);
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean registrarHorarioMaternidad(int codigo, Date inicio, Date fin) {
        try {
            String cod_archivo_detalle = "1";
            String codigo_archivo = "SELECT (MAX(COD_MATERNIDAD) + 1) AS NUEVO_CODIGO FROM PERSONAL_MATERNIDAD";
            ResultSet rs_codigo_archivo = this.ejecutaConsulta(codigo_archivo);
            if (rs_codigo_archivo.next()) {
                cod_archivo_detalle = rs_codigo_archivo.getString("NUEVO_CODIGO");
                if (cod_archivo_detalle == null) {
                    cod_archivo_detalle = "1";
                }
            }
            String inserta_registro = "INSERT INTO PERSONAL_MATERNIDAD VALUES(" + cod_archivo_detalle + ", " + codigo + ", '" + TimeFunction.formatearFecha(inicio) + "', '" + TimeFunction.formatearFecha(fin) + "', 1)";
            int resultado = this.ejecutaActualizacion(inserta_registro);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarPermisoHora(int codigo) {
        try {
            String eliminar_marcado = "DELETE FROM PERSONAL_PERMISOS WHERE COD_PERMISO=" + codigo;
            int r = this.ejecutaActualizacion(eliminar_marcado);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarPermisoTurno(int codigo) {
        try {
            String eliminar_marcado = "DELETE FROM PERSONAL_PERMISOS_TURNO WHERE COD_PERMISO_TURNO=" + codigo;
            int r = this.ejecutaActualizacion(eliminar_marcado);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarPermisoFecha(int codigo) {
        try {
            String eliminar_marcado = "DELETE FROM PERSONAL_PERMISOS_DIA WHERE COD_PERMISO_DIA=" + codigo;
            int r = this.ejecutaActualizacion(eliminar_marcado);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean registrarFechaGeneracionVacacion(Date fecha) {
        try {
            String cod_archivo_detalle = "1";
            String codigo = "SELECT (MAX(COD_GENERACION) + 1) AS NUEVO_CODIGO FROM GENERACION_VACACION";
            ResultSet rs_codigo = this.ejecutaConsulta(codigo);
            if (rs_codigo.next()) {
                cod_archivo_detalle = rs_codigo.getString("NUEVO_CODIGO");
                if (cod_archivo_detalle == null) {
                    cod_archivo_detalle = "1";
                }
            }
            String inserta_registro = "INSERT INTO GENERACION_VACACION VALUES(" + cod_archivo_detalle + ", '" + TimeFunction.formatearFecha(fecha) + "')";
            int resultado = this.ejecutaActualizacion(inserta_registro);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean compararFechaGeneracion(Date fecha) {
        try {
            String query = "SELECT FECHA FROM GENERACION_VACACION WHERE FECHA='" + TimeFunction.formatearFecha(fecha) + "'";
            ResultSet rs = this.ejecutaConsulta(query);
            return (rs.next());
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

    }

    public int obtenerDivisionPersonal(int codigo) {
        try {
            int resultado = 0;
            String query = "SELECT E.DIVISION FROM PERSONAL P INNER JOIN AREAS_EMPRESA E ON(E.COD_AREA_EMPRESA=P.COD_AREA_EMPRESA) WHERE P.COD_PERSONAL=" + codigo;
            ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                resultado = rs.getInt("DIVISION");
            }
            return resultado;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public boolean agregarQuinquenio(int codigo, Date fechaQuinquenio, Date pagoQuinquenio, double monto, String observacion) {
        try {
            String codigo_permiso = "SELECT (MAX(COD_QUINQUENIO) + 1) AS NUEVO_CODIGO FROM QUINQUENIOS";
            ResultSet rs_codigo_quinquenio = this.ejecutaConsulta(codigo_permiso);
            String cod_quinquenio = null;
            if (rs_codigo_quinquenio.next()) {
                cod_quinquenio = rs_codigo_quinquenio.getString("NUEVO_CODIGO");
                if (cod_quinquenio == null) {
                    cod_quinquenio = "1";
                }
            }
            String insertar_quinquenio = "INSERT INTO QUINQUENIOS VALUES(" + codigo + ", '" + TimeFunction.formatearFecha(fechaQuinquenio) + "', ";
            insertar_quinquenio += "'" + TimeFunction.formatearFecha(pagoQuinquenio) + "', " + monto + ", '" + observacion + "'," + cod_quinquenio + ")";
            int rs_inserta_control = this.ejecutaActualizacion(insertar_quinquenio);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean borrarQuinquenio(int codigo) {
        try {
            String borrar_quinquenio = "DELETE FROM QUINQUENIOS WHERE COD_QUINQUENIO=" + codigo;
            int rs_borrar_quinquenio = this.ejecutaActualizacion(borrar_quinquenio);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List listaQuinqueniosPagados() {
        try {
            List resultList = new ArrayList();
            String query = "SELECT Q.COD_QUINQUENIO, Q.FECHA_CUMPLE_QUINQUENIO, Q.FECHA_PAGO_QUINQUENIO, Q.MONTO_PAGO_QUINQUENIO, Q.OBS_QUINQUENIO, P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + P.NOMBRES_PERSONAL AS NOMBRE_COMPLETO FROM PERSONAL P INNER JOIN QUINQUENIOS Q ON(P.COD_PERSONAL=Q.COD_PERSONAL) ORDER BY Q.FECHA_PAGO_QUINQUENIO";
            ResultSet rs = this.ejecutaConsulta(query);
            while (rs.next()) {
                resultList.add(new Quinquenios(rs.getInt("COD_QUINQUENIO"), rs.getString("NOMBRE_COMPLETO"), rs.getDate("FECHA_CUMPLE_QUINQUENIO"), rs.getDate("FECHA_PAGO_QUINQUENIO"), rs.getDouble("MONTO_PAGO_QUINQUENIO"), rs.getString("OBS_QUINQUENIO")));
            }
            return (resultList.size() > 0 ? resultList : null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean agregarMesDominical(int gestion, int mes) {
        try {
            String codigo_dominical = "SELECT (MAX(D.COD_APROB_DOMINICAL) + 1) AS NUEVO_CODIGO FROM APROBACION_DOMINICAL D";
            ResultSet rs_codigo_dominical = this.ejecutaConsulta(codigo_dominical);
            String cod_dominical = null;
            if (rs_codigo_dominical.next()) {
                cod_dominical = rs_codigo_dominical.getString("NUEVO_CODIGO");
                if (cod_dominical == null) {
                    cod_dominical = "1";
                }
            }
            String insertar_dominical = "INSERT INTO APROBACION_DOMINICAL VALUES(" + cod_dominical + "," + gestion + "," + mes + ")";
            int rs_inserta_control = this.ejecutaActualizacion(insertar_dominical);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarMesDominical(int codigo) {
        try {
            String borrar_dominical = "DELETE FROM APROBACION_DOMINICAL WHERE COD_APROB_DOMINICAL=" + codigo;
            int rs_borrar_dominical = this.ejecutaActualizacion(borrar_dominical);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarMesRefrigerio(int codigo) {
        try {
            String borrar_refrigerio = "DELETE FROM APROBACION_REFRIGERIO WHERE COD_APROB_REFRIGERIO=" + codigo;
            int rs_borrar_refrigerio = this.ejecutaActualizacion(borrar_refrigerio);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public AprobacionDominical buscarAprobacionDominical(int codigo) {
        AprobacionDominical resultado = null;
        try {
            String query = "SELECT D.COD_APROB_DOMINICAL, G.COD_GESTION, M.COD_MES, G.NOMBRE_GESTION, M.NOMBRE_MES FROM APROBACION_DOMINICAL D INNER JOIN GESTIONES G ON(G.COD_GESTION=D.COD_GESTION) INNER JOIN MESES M ON(M.COD_MES=D.COD_MES) WHERE D.COD_APROB_DOMINICAL=" + codigo;
            ResultSet rs = ejecutaConsulta(query);
            if (rs.next()) {
                resultado = new AprobacionDominical(rs.getInt("COD_APROB_DOMINICAL"), rs.getInt("COD_GESTION"), rs.getInt("COD_MES"), rs.getString("NOMBRE_GESTION"), rs.getString("NOMBRE_MES"));
            }
            return resultado;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean guardarAprobacionDominical(List<AprobacionDominicalDetalle> aprobaciones) {
        try {
            Iterator index = aprobaciones.iterator();
            while (index.hasNext()) {
                AprobacionDominicalDetalle aprobacion = (AprobacionDominicalDetalle) index.next();
                if (aprobacion.getChecked().booleanValue()) {
                    String query = "INSERT INTO APROBACION_DOMINICALDETALLE VALUES (" + aprobacion.getCodigoAprobacion() + ", " + aprobacion.getCodigoPersonal() + ", " + aprobacion.getBase() + ", " + aprobacion.getAprobado() + ")";
                    int result = this.ejecutaActualizacion(query);
                }
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean guardarAprobacionRefrigerio(List<AprobacionRefrigerioDetalle> aprobaciones) {
        try {
            Iterator index = aprobaciones.iterator();
            while (index.hasNext()) {
                AprobacionRefrigerioDetalle aprobacion = (AprobacionRefrigerioDetalle) index.next();
                if (aprobacion.getChecked().booleanValue()) {
                    String query = "INSERT INTO APROBACION_REFRIGERIODETALLE VALUES (" + aprobacion.getCodigoAprobacion() + ", " + aprobacion.getCodigoPersonal() + ", " + aprobacion.getBase() + ", " + aprobacion.getAprobado() + ")";
                    int result = this.ejecutaActualizacion(query);
                }
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarAprobacionDominical(List<AprobacionDominicalDetalle> aprobaciones) {
        try {
            Iterator index = aprobaciones.iterator();
            while (index.hasNext()) {
                AprobacionDominicalDetalle aprobacion = (AprobacionDominicalDetalle) index.next();
                if (aprobacion.getChecked().booleanValue()) {
                    String query = "DELETE FROM APROBACION_DOMINICALDETALLE WHERE COD_APROB_DOMINICAL=" + aprobacion.getCodigoAprobacion() + " AND COD_PERSONAL=" + aprobacion.getCodigoPersonal();
                    int result = this.ejecutaActualizacion(query);
                }
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarAprobacionRefrigerio(List<AprobacionRefrigerioDetalle> aprobaciones) {
        try {
            Iterator index = aprobaciones.iterator();
            while (index.hasNext()) {
                AprobacionRefrigerioDetalle aprobacion = (AprobacionRefrigerioDetalle) index.next();
                if (aprobacion.getChecked().booleanValue()) {
                    String query = "DELETE FROM APROBACION_REFRIGERIODETALLE WHERE COD_APROB_REFRIGERIO=" + aprobacion.getCodigoAprobacion() + " AND COD_PERSONAL=" + aprobacion.getCodigoPersonal();
                    int result = this.ejecutaActualizacion(query);
                }
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean agregarMesRefrigerio(int gestion, int mes) {
        try {
            String codigo_refrigerio = "SELECT (MAX(D.COD_APROB_REFRIGERIO) + 1) AS NUEVO_CODIGO FROM APROBACION_REFRIGERIO D";
            ResultSet rs_codigo_refrigerio = this.ejecutaConsulta(codigo_refrigerio);
            String cod_refrigerio = null;
            if (rs_codigo_refrigerio.next()) {
                cod_refrigerio = rs_codigo_refrigerio.getString("NUEVO_CODIGO");
                if (cod_refrigerio == null) {
                    cod_refrigerio = "1";
                }
            }
            String insertar_dominical = "INSERT INTO APROBACION_REFRIGERIO VALUES(" + cod_refrigerio + "," + gestion + "," + mes + ")";
            int rs_inserta_control = this.ejecutaActualizacion(insertar_dominical);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public AprobacionRefrigerio buscarAprobacionRefrigerio(int codigo) {
        AprobacionRefrigerio resultado = null;
        try {
            String query = "SELECT D.COD_APROB_REFRIGERIO, G.COD_GESTION, M.COD_MES, G.NOMBRE_GESTION, M.NOMBRE_MES FROM APROBACION_REFRIGERIO D INNER JOIN GESTIONES G ON(G.COD_GESTION=D.COD_GESTION) INNER JOIN MESES M ON(M.COD_MES=D.COD_MES) WHERE D.COD_APROB_REFRIGERIO=" + codigo;
            ResultSet rs = ejecutaConsulta(query);
            if (rs.next()) {
                resultado = new AprobacionRefrigerio(rs.getInt("COD_APROB_REFRIGERIO"), rs.getInt("COD_GESTION"), rs.getInt("COD_MES"), rs.getString("NOMBRE_GESTION"), rs.getString("NOMBRE_MES"));
            }
            return resultado;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Date> fechasPagoRefrigerio(Date inicio, Date fin) {
        DateTime comienzo = new DateTime(inicio);
        DateTime conclusion = new DateTime(fin).plusDays(1);
        List<Date> resultList = new ArrayList();
        while (comienzo.isBefore(conclusion)) {
            if (comienzo.getDayOfWeek() > 5) {
                resultList.add(comienzo.toDate());
            } else {
                if (this.isFeriado(comienzo.toDate())) {
                    resultList.add(comienzo.toDate());
                }
            }
            comienzo = comienzo.plusDays(1);
        }
        return resultList;
    }

    public boolean contieneAprobacionDominicalDetalle(int codigo) {
        try {
            String query = "SELECT * FROM APROBACION_DOMINICALDETALLE T WHERE T.COD_APROB_DOMINICAL=" + codigo;
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

    public boolean contieneAprobacionRefrigerioDetalle(int codigo) {
        try {
            String query = "SELECT * FROM APROBACION_REFRIGERIODETALLE T WHERE T.COD_APROB_REFRIGERIO=" + codigo;
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
}
