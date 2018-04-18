/*
 * Asistencia.java
 *
 * Created on 18 de octubre de 2010, 10:47 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package com.cofar.bean.util;

import com.cofar.util.StyleFunction;
import com.cofar.util.TimeFunction;
import java.util.Date;
import java.util.List;
import org.joda.time.DateTime;
import org.joda.time.Minutes;

/**
 *
 * @author Ismael Juchazara
 */
public class Asistencia {

    private int codigo;
    private List<PermisoHorario> permisos;
    private Date fecha;
    private int sexo;
    private DateTime primerIngreso;
    private DateTime primerSalida;
    private DateTime segundoIngreso;
    private DateTime segundoSalida;
    private Justificacion primeraJustificacion;
    private Justificacion segundaJustificacion;
    private int minutosExcedente;
    private int minutosFaltante;
    private boolean excedente = false;
    private int minutosLaboral;
    private int minutosNominal;
    private int minutosTrabajado;
    private int minutosComputable;
    private int minutosRealTrabajado;
    private int minutosVacacion;
    private int tipoVacacion;
    private int tipoPermiso;
    private int tipoPermisoSegundo;
    private int minutosPrimerNocturno;
    private int minutosSegundoNocturno;
    private String observacion;
    private String tipoObservacion;
    private double importeDevolucion;
    private double promedioDevolucion;
    private String color;

    public Asistencia(int codigo, Date fecha, DateTime pIngreso, DateTime pSalida, DateTime sIngreso, DateTime sSalida, int sexo, int division, Justificacion pjust, Justificacion sjust, List permisos, boolean maternidad, boolean confianza) {
        this.codigo = codigo;
        this.permisos = permisos;
        this.fecha = fecha;
        DateTime rfecha = new DateTime(fecha);
        this.color = StyleFunction.estiloDia(fecha, sexo, division);
        this.setPrimerIngreso(pIngreso);
        this.setPrimerSalida(pSalida);
        this.setSegundoIngreso(sIngreso);
        this.setSegundoSalida(sSalida);
        this.sexo = sexo;
        this.primeraJustificacion = pjust;
        this.segundaJustificacion = sjust;
        this.minutosLaboral = TimeFunction.calculaMinutosLaboral(rfecha, this.primerIngreso, this.primerSalida, division, sexo, codigo);
        this.minutosNominal = this.minutosLaboral;
        this.calculaTiempoTrabajado();
        if (confianza) {
            this.minutosTrabajado = this.minutosLaboral;
            this.minutosComputable = this.minutosLaboral;
            this.minutosRealTrabajado = this.minutosComputable;
            this.minutosExcedente = 0;
            this.minutosFaltante = 0;
            this.minutosPrimerNocturno = 0;
            this.minutosSegundoNocturno = 0;

        } else {
            if (this.primeraJustificacion != null) {
                if (this.primeraJustificacion.getTipo() > 1) {
                    if (this.minutosLaboral > 0) {
                        this.minutosLaboral = this.minutosLaboral - this.primeraJustificacion.getMinutos();
                    }
                }
            }
            if (this.segundaJustificacion != null) {
                if (this.segundaJustificacion.getTipo() > 1) {
                    if (this.minutosLaboral > 0) {
                        this.minutosLaboral = this.minutosLaboral - this.segundaJustificacion.getMinutos();
                    }
                }
            }
            if ((maternidad) && (this.minutosLaboral > 0)) {
                this.minutosLaboral = this.minutosLaboral - 60;
            }
            if (this.permisos != null) {
                for (PermisoHorario permiso : this.permisos) {
                    if (permiso.getTipo() > 1) {
                        int minutos = TimeFunction.minutosPermisoEntreMarcados(this, permiso);
                        if ((minutos <= 0) || (permiso.getTipo() == 2)) {
                            this.minutosLaboral = this.minutosLaboral - permiso.getMinutos();
                        }
                    }
                    if (permiso.getTipo() < 3) {
                        this.minutosTrabajado = this.minutosTrabajado - TimeFunction.minutosPermisoEntreMarcados(this, permiso);
                    }
                }
            }

            this.excedente = this.minutosTrabajado - this.getMinutosLaboral() > 0 ? true : false;
            if (this.minutosTrabajado > 0) {
                this.minutosExcedente = Math.abs(this.minutosTrabajado - this.getMinutosLaboral());
            } else {
                this.minutosExcedente = 0;
            }
            this.setMinutosComputable(this.minutosTrabajado - (this.minutosTrabajado % 30));
            this.setMinutosPrimerNocturno(this.getPrimerTurnoNocturno());
            this.setMinutosSegundoNocturno(this.getSegundoTurnoNocturno());
            this.importeDevolucion = this.calcularImporteDevolucion();
        }
    }

    private void calculaTiempoTrabajado() {
        int primerTotal = 0;
        int segundoTotal = 0;
        int total_tiempo = 0;
        if ((this.primerIngreso != null) && (this.primerSalida != null)) {
            primerTotal = Minutes.minutesBetween(this.primerIngreso, this.primerSalida).getMinutes();
        }
        if ((this.segundoIngreso != null) && (this.segundoSalida != null)) {
            segundoTotal = Minutes.minutesBetween(this.segundoIngreso, this.segundoSalida).getMinutes();
        }
        this.setMinutosRealTrabajado(primerTotal + segundoTotal);
        switch (this.tipoVacacion) {
            case 1:
                total_tiempo = (this.sexo == 1 ? 240 : 210) + segundoTotal;
                this.setMinutosVacacion(this.sexo == 1 ? 240 : 210);
                break;
            case 2:
                total_tiempo = primerTotal + (this.sexo == 1 ? 240 : 270);
                this.setMinutosVacacion(this.sexo == 1 ? 240 : 270);
                break;
            case 3:
                total_tiempo = this.getMinutosLaboral();
                this.setMinutosVacacion(total_tiempo);
                break;
            default:
                total_tiempo = primerTotal + segundoTotal;
                this.setMinutosVacacion(0);
                break;
        }
        this.setMinutosTrabajado(total_tiempo);
    }

    public String getTiempoLaboral() {
        return (TimeFunction.convierteHorasMinutos((this.minutosLaboral > 0 ? this.minutosLaboral : 0)));
    }

    public int getPrimerTurnoNocturno() {
        int tiempo1 = 0;
        int tiempo2 = 0;
        if ((this.primerIngreso != null) && (this.primerSalida != null)) {
            tiempo1 = TimeFunction.minutosPrimerTurnoNocturno(this.primerIngreso, this.primerSalida);
        }
        if ((this.segundoIngreso != null) && (this.segundoSalida != null)) {
            tiempo2 = TimeFunction.minutosPrimerTurnoNocturno(this.segundoIngreso, this.segundoSalida);
        }
        return (tiempo1 + tiempo2);
    }

    public int getSegundoTurnoNocturno() {
        int tiempo1 = 0;
        int tiempo2 = 0;
        if ((this.primerIngreso != null) && (this.primerSalida != null)) {
            tiempo1 = TimeFunction.minutosSegundoTurnoNocturno(this.primerIngreso, this.primerSalida);
        }
        if ((this.segundoIngreso != null) && (this.segundoSalida != null)) {
            tiempo2 = TimeFunction.minutosSegundoTurnoNocturno(this.segundoIngreso, this.segundoSalida);
        }
        return (tiempo1 + tiempo2);
    }

    /** Creates a new instance of Asistencia */
    public Asistencia() {
    }

    public String getTotalMinutosPrimerNocturno() {
        if (this.getMinutosPrimerNocturno() > 0) {
            int total_tiempo = this.getMinutosPrimerNocturno() - (this.getMinutosPrimerNocturno() % 30);
            return (TimeFunction.convierteHorasMinutos(total_tiempo));
        } else {
            return null;
        }
    }

    public String getTotalMinutosSegundoNocturno() {
        if (this.getMinutosSegundoNocturno() > 0) {
            int total_tiempo = this.getMinutosSegundoNocturno() - (this.getMinutosSegundoNocturno() % 30);
            int horas = (int) (total_tiempo / 60);
            int minutos = (int) (total_tiempo % 60);
            return (TimeFunction.convierteHorasMinutos(total_tiempo));
        } else {
            return null;
        }
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public Date getPrimerIngreso() {
        return (primerIngreso != null ? primerIngreso.toDate() : null);
    }

    public DateTime getDatePrimerIngreso() {
        return primerIngreso;
    }

    public void setPrimerIngreso(DateTime primerIngreso) {
        this.primerIngreso = primerIngreso;
    }

    public Date getPrimerSalida() {
        return (primerSalida != null ? primerSalida.toDate() : null);
    }

    public DateTime getDatePrimerSalida() {
        return primerSalida;
    }

    public void setPrimerSalida(DateTime primerSalida) {
        this.primerSalida = primerSalida;
    }

    public Date getSegundoIngreso() {
        return (segundoIngreso != null ? segundoIngreso.toDate() : null);
    }

    public DateTime getDateSegundoIngreso() {
        return segundoIngreso;
    }

    public void setSegundoIngreso(DateTime segundoIngreso) {
        this.segundoIngreso = segundoIngreso;
    }

    public Date getSegundoSalida() {
        return (segundoSalida != null ? segundoSalida.toDate() : null);
    }

    public DateTime getDateSegundoSalida() {
        return segundoSalida;
    }

    public void setSegundoSalida(DateTime segundoSalida) {
        this.segundoSalida = segundoSalida;
    }

    public int getTotalMinutosFaltante() {
        int faltante = this.getMinutosLaboral() - this.minutosTrabajado;
        return (faltante > 0 ? faltante : 0);
    }

    public String getTotalFaltante() {
        return (TimeFunction.convierteHorasMinutos(this.getTotalMinutosFaltante()));
    }

    public String getTotalTrabajado() {
        return (TimeFunction.convierteHorasMinutos(this.minutosTrabajado));
    }

    public boolean isExcedente() {
        return excedente;
    }

    public void setExcedente(boolean excedente) {
        this.excedente = excedente;
    }

    public int totalMinutosSobrantes() {
        int diferencia = this.minutosTrabajado - this.getMinutosLaboral();
        if (diferencia > 0) {
            diferencia = diferencia - (diferencia % 30);
        }
        return (diferencia > 0 ? diferencia : 0);
    }

    public int totalMinutosFaltante() {
        int diferencia = this.getMinutosLaboral() - this.minutosTrabajado;
        return (diferencia > 0 ? diferencia : 0);
    }

    public String getTotalExcedente() {
        return (TimeFunction.convierteHorasMinutos(this.getTotalMinutosExcedente()));
    }

    public int getTotalMinutosExcedente() {
        if (this.excedente) {
            int extras = this.minutosExcedente - (this.minutosExcedente % 30);
            return extras;
        } else {
            return 0;
        }
    }

    /*public int getTotalMinutosFaltante(){
    if(!this.excedente){
    int extras = this.minutosExcedente - (this.minutosExcedente % 30);
    return extras;
    }else{
    return 0;
    }
    }*/
    public String getTotalComputable() {
        return (TimeFunction.convierteHorasMinutos(this.minutosComputable));
    }

    public int getMinutosExcedente() {
        return minutosExcedente;
    }

    public void setMinutosExcedente(int minutosExcedente) {
        this.minutosExcedente = minutosExcedente;
    }

    public int getMinutosTrabajado() {
        return minutosTrabajado;
    }

    public void setMinutosTrabajado(int minutosTrabajado) {
        this.minutosTrabajado = minutosTrabajado;
    }

    public int getTipoVacacion() {
        return tipoVacacion;
    }

    public void setTipoVacacion(int tipoVacacion) {
        this.tipoVacacion = tipoVacacion;
        this.calculaTiempoTrabajado();
    }

    public int getMinutosPrimerNocturno() {
        return minutosPrimerNocturno;
    }

    public void setMinutosPrimerNocturno(int minutosPrimerNocturno) {
        this.minutosPrimerNocturno = minutosPrimerNocturno;
    }

    public int getMinutosSegundoNocturno() {
        return minutosSegundoNocturno;
    }

    public void setMinutosSegundoNocturno(int minutosSegundoNocturno) {
        this.minutosSegundoNocturno = minutosSegundoNocturno;
    }

    public int getSexo() {
        return sexo;
    }

    public void setSexo(int sexo) {
        this.sexo = sexo;
    }

    public int getMinutosLaboral() {
        return minutosLaboral;
    }

    public void setMinutosLaboral(int minutosLaboral) {
        this.minutosLaboral = minutosLaboral;
    }

    public double calcularImporteDevolucion() {
        double resultado = 0;
        if ((this.primerIngreso != null) && (this.primerSalida != null)) {
            if (this.primerIngreso.getDayOfWeek() != this.primerSalida.getDayOfWeek()) {
                resultado = 8.40;
            } else {
                if (this.segundoIngreso != null && this.segundoSalida != null) {
                    if (TimeFunction.diferenciaTiempo(this.primerSalida, this.segundoIngreso) > 45) {
                        resultado = 12.60;
                    } else {
                        resultado = 8.40;
                    }
                } else {
                    if (this.minutosTrabajado > 390) {
                        resultado = 8.40;
                    } else {
                        resultado = 6.30;
                    }
                }
            }
        } else {
            if (this.segundoIngreso != null && this.segundoSalida != null) {
                if (this.minutosTrabajado > 390) {
                    resultado = 8.40;
                } else {
                    resultado = 6.30;
                }
            }
        }
        return resultado;
    }

    /*public double calcularImporteDevolucion(int division){
    double resultado = 0;
    if((division<3)||(this.codigo==277)){
    if((this.primerIngreso!=null) && (this.primerSalida!=null)){
    if(this.segundoIngreso!=null && this.segundoSalida!=null){
    resultado = 12.60;
    }else{
    resultado = 6.30;
    }
    }else{
    if(this.segundoIngreso!=null && this.segundoSalida!=null){
    resultado = 6.30;
    }
    }
    }else{
    if((this.primerIngreso!=null) && (this.primerSalida!=null)){
    resultado = 8.40;
    }else{
    if(this.segundoIngreso!=null && this.segundoSalida!=null){
    resultado = 8.40;
    }
    }
    }
    return resultado;
    }*/
    public int minutosVacacion() {
        int resultado = 0;
        switch (this.tipoVacacion) {
            case 1:
                resultado = 240;
                break;
            case 2:
                resultado = 240;
                break;
            case 3:
                resultado = 480;
                break;
        }
        return resultado;
    }

    public double getImporteDevolucion() {
        return importeDevolucion;
    }

    public int getMinutosRealTrabajado() {
        return minutosRealTrabajado;
    }

    public void setMinutosRealTrabajado(int minutosRealTrabajado) {
        this.minutosRealTrabajado = minutosRealTrabajado;
    }

    public int getMinutosVacacion() {
        return minutosVacacion;
    }

    public void setMinutosVacacion(int minutosVacacion) {
        this.minutosVacacion = minutosVacacion;
    }

    public int getTipoPermiso() {
        return tipoPermiso;
    }

    public void setTipoPermiso(int tipoPermiso) {
        this.tipoPermiso = tipoPermiso;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public int getMinutosComputable() {
        return (this.getMinutosTrabajado() - (this.getMinutosTrabajado() % 30));
    }

    public void setMinutosComputable(int minutosComputable) {
        this.minutosComputable = minutosComputable;
    }

    public String getTipoObservacion() {
        return tipoObservacion;
    }

    public void setTipoObservacion(String tipoObservacion) {
        this.tipoObservacion = tipoObservacion;
    }

    /*    public int getMinutosPermiso() {
    return minutosPermiso;
    }

    public void setMinutosPermiso(int minutosPermiso) {
    this.minutosPermiso = minutosPermiso;
    }
     */
    public int getTipoPermisoSegundo() {
        return tipoPermisoSegundo;
    }

    public void setTipoPermisoSegundo(int tipoPermisoSegundo) {
        this.tipoPermisoSegundo = tipoPermisoSegundo;
    }

    public double getPromedioDevolucion() {
        return promedioDevolucion;
    }

    public void setPromedioDevolucion(double promedioDevolucion) {
        this.promedioDevolucion = promedioDevolucion;
    }

    public Justificacion getPrimeraJustificacion() {
        return primeraJustificacion;
    }

    public void setPrimeraJustificacion(Justificacion primeraJustificacion) {
        this.primeraJustificacion = primeraJustificacion;
    }

    public Justificacion getSegundaJustificacion() {
        return segundaJustificacion;
    }

    public void setSegundaJustificacion(Justificacion segundaJustificacion) {
        this.segundaJustificacion = segundaJustificacion;
    }

    public List<PermisoHorario> getPermisos() {
        return permisos;
    }

    public void setPermisos(List<PermisoHorario> permisos) {
        this.permisos = permisos;
    }

    public int getMinutosNominal() {
        return minutosNominal;
    }

    public void setMinutosNominal(int minutosNominal) {
        this.minutosNominal = minutosNominal;
    }

    public DateTime getPrimerIngresoTime() {
        return this.primerIngreso;
    }

    public DateTime getPrimerSalidaTime() {
        return this.primerSalida;
    }

    public DateTime getSegundoIngresoTime() {
        return this.segundoIngreso;
    }

    public DateTime getSegundoSalidaTime() {
        return this.segundoSalida;
    }

    public int getCodigo() {
        return codigo;
    }

    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }
}
