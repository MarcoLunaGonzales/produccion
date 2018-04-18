/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean.util;

import java.util.Date;

/**
 *
 * @author Ismael Juchazara
 */
public class PersonalFiniquito {
    
    private String nombre;
    private String cargo;
    private int edad;
    private String direccion;
    private String civil;
    private String ci;
    private Date ingreso;
    private Date retiro;
    private String motivo;
    private double salario;
    private MesFiniquito primerMes;
    private MesFiniquito segundoMes;
    private MesFiniquito tercerMes;
    private BeneficioFiniquito beneficios;
    private Double totalSalario;
    private Double totalDominical;
    private Double totalReintegro;
    private Double totalComision;
    private Double totalExtras;
    private Double totalNocturno;
    private Double totalAntiguedad;
    private Double totalParcial;
    private Double promedioIndemnizable;
    private Double importePagable;
    private int anioServicio;
    private int mesServicio;
    private int diaServicio;

    /**/

    private String pago_efectivo;
    private String pago_cheque;
    private String numero_cheque;
    private String nombre_banco;
    private String cod_personal;
    private Double monto_pago;
    private String monto_pago_literal;
    private int  dias_ultimo_salario;
    private Double monto_ultimo_salario;
    private String nombreAreaEmpresa;
    


    public PersonalFiniquito(String pago_efectivo,String pago_cheque,String numero_cheque,String nombre_banco,String cod_personal,Double monto_pago,String monto_pago_literal,String ci,String nombre,String nombreAreaEmpresa  ){

        System.out.println("pago_efectivo:"+pago_efectivo);
        System.out.println("pago_cheque:"+pago_cheque);
        System.out.println("numero_cheque:"+numero_cheque);
        System.out.println("nombre_banco:"+nombre_banco);
        System.out.println("cod_personal:"+cod_personal);
        System.out.println("monto_pago:"+monto_pago);
        System.out.println("monto_pago_literal:"+monto_pago_literal);
        System.out.println("ci:"+ci);
        System.out.println("nombre:"+nombre);
        System.out.println("nombreAreaEmpresa:"+nombreAreaEmpresa);
        this.pago_efectivo=pago_efectivo;
        this.pago_cheque=pago_cheque;
        this.numero_cheque=numero_cheque;
        this.nombre_banco=nombre_banco;
        this.cod_personal=cod_personal;
        this.monto_pago=monto_pago;
        this.monto_pago_literal=monto_pago_literal;
        this.ci=ci;
        this.nombre=nombre;
        this.nombreAreaEmpresa=nombreAreaEmpresa;
        
    }
    public PersonalFiniquito(String nombre, String cargo, int edad, String direccion, String civil, String ci, Date ingreso, Date retiro, String motivo, Double salario, MesFiniquito primerMes, MesFiniquito segundoMes, MesFiniquito tercerMes, BeneficioFiniquito beneficio, int anioServicio, int mesServicio, int diaServicio,int dias_ultimo_salario, double monto_ultimo_salario) {
        this.nombre = nombre;
        this.cargo = cargo;
        this.edad = edad;
        this.direccion = direccion;
        this.civil = civil;
        this.ci = ci;
        this.ingreso = ingreso;
        this.retiro = retiro;
        this.motivo = motivo;
        this.salario = salario;
        this.primerMes = primerMes;
        this.segundoMes = segundoMes;
        this.tercerMes = tercerMes;
        System.out.println("primerMes:"+primerMes);
        System.out.println("segundoMes:"+segundoMes);
        System.out.println("tercerMes:"+tercerMes);
        this.anioServicio = anioServicio;
        this.mesServicio = mesServicio;
        this.diaServicio = diaServicio;
        
        this.totalSalario = this.primerMes.getSalario() + this.segundoMes.getSalario() + this.tercerMes.getSalario();
        this.totalDominical = this.primerMes.getDominical() + this.segundoMes.getDominical() + this.tercerMes.getDominical();
        this.totalReintegro = this.primerMes.getReintegro() + this.segundoMes.getReintegro() + this.tercerMes.getReintegro();
        this.totalComision = this.primerMes.getComision() + this.segundoMes.getComision() + this.tercerMes.getComision();
        
        this.totalExtras = this.primerMes.getExtras() + this.segundoMes.getExtras() + this.tercerMes.getExtras();
        this.totalNocturno = this.primerMes.getNocturno() + this.segundoMes.getNocturno() + this.tercerMes.getNocturno();
        this.totalAntiguedad = this.primerMes.getAntiguedad() + this.segundoMes.getAntiguedad() + this.tercerMes.getAntiguedad();
        this.totalParcial = this.primerMes.getTotal() + this.segundoMes.getTotal() + this.tercerMes.getTotal();
        this.promedioIndemnizable = this.totalParcial / 3;
        this.beneficios = beneficio;
        
        this.dias_ultimo_salario=dias_ultimo_salario;
        this.monto_ultimo_salario=monto_ultimo_salario;
        this.importePagable = this.beneficios.getTotalBeneficios() - this.beneficios.getTotalDeduccion()+this.monto_ultimo_salario;
        
    }
    
    /**
     * @return the nombre
     */
    public String getNombre() {
        return nombre;
    }
    
    /**
     * @param nombre the nombre to set
     */
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    /**
     * @return the cargo
     */
    public String getCargo() {
        return cargo;
    }
    
    /**
     * @param cargo the cargo to set
     */
    public void setCargo(String cargo) {
        this.cargo = cargo;
    }
    
    /**
     * @return the edad
     */
    public int getEdad() {
        return edad;
    }
    
    /**
     * @param edad the edad to set
     */
    public void setEdad(int edad) {
        this.edad = edad;
    }
    
    /**
     * @return the direccion
     */
    public String getDireccion() {
        return direccion;
    }
    
    /**
     * @param direccion the direccion to set
     */
    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }
    
    /**
     * @return the civil
     */
    public String getCivil() {
        return civil;
    }
    
    /**
     * @param civil the civil to set
     */
    public void setCivil(String civil) {
        this.civil = civil;
    }
    
    /**
     * @return the ci
     */
    public String getCi() {
        return ci;
    }
    
    /**
     * @param ci the ci to set
     */
    public void setCi(String ci) {
        this.ci = ci;
    }
    
    /**
     * @return the ingreso
     */
    public Date getIngreso() {
        return ingreso;
    }
    
    /**
     * @param ingreso the ingreso to set
     */
    public void setIngreso(Date ingreso) {
        this.ingreso = ingreso;
    }
    
    /**
     * @return the retiro
     */
    public Date getRetiro() {
        return retiro;
    }
    
    /**
     * @param retiro the retiro to set
     */
    public void setRetiro(Date retiro) {
        this.retiro = retiro;
    }
    
    /**
     * @return the motivo
     */
    public String getMotivo() {
        return motivo;
    }
    
    /**
     * @param motivo the motivo to set
     */
    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }
    
    /**
     * @return the salario
     */
    public double getSalario() {
        return salario;
    }
    
    /**
     * @param salario the salario to set
     */
    public void setSalario(double salario) {
        this.salario = salario;
    }
    
    /**
     * @return the primerMes
     */
    public MesFiniquito getPrimerMes() {
        return primerMes;
    }
    
    /**
     * @param primerMes the primerMes to set
     */
    public void setPrimerMes(MesFiniquito primerMes) {
        this.primerMes = primerMes;
    }
    
    /**
     * @return the segundoMes
     */
    public MesFiniquito getSegundoMes() {
        return segundoMes;
    }
    
    /**
     * @param segundoMes the segundoMes to set
     */
    public void setSegundoMes(MesFiniquito segundoMes) {
        this.segundoMes = segundoMes;
    }
    
    /**
     * @return the tercerMes
     */
    public MesFiniquito getTercerMes() {
        return tercerMes;
    }
    
    /**
     * @param tercerMes the tercerMes to set
     */
    public void setTercerMes(MesFiniquito tercerMes) {
        this.tercerMes = tercerMes;
    }
    
    /**
     * @return the totalSalario
     */
    public Double getTotalSalario() {
        return totalSalario;
    }
    
    /**
     * @param totalSalario the totalSalario to set
     */
    public void setTotalSalario(Double totalSalario) {
        this.totalSalario = totalSalario;
    }
    
    /**
     * @return the totalDominical
     */
    public Double getTotalDominical() {
        return totalDominical;
    }
    
    /**
     * @param totalDominical the totalDominical to set
     */
    public void setTotalDominical(Double totalDominical) {
        this.totalDominical = totalDominical;
    }
    
    /**
     * @return the totalReintegro
     */
    public Double getTotalReintegro() {
        return totalReintegro;
    }
    
    /**
     * @param totalReintegro the totalReintegro to set
     */
    public void setTotalReintegro(Double totalReintegro) {
        this.totalReintegro = totalReintegro;
    }
    
    /**
     * @return the totalComision
     */
    public Double getTotalComision() {
        return totalComision;
    }
    
    /**
     * @param totalComision the totalComision to set
     */
    public void setTotalComision(Double totalComision) {
        this.totalComision = totalComision;
    }
    
    /**
     * @return the totalExtras
     */
    public Double getTotalExtras() {
        return totalExtras;
    }
    
    /**
     * @param totalExtras the totalExtras to set
     */
    public void setTotalExtras(Double totalExtras) {
        this.totalExtras = totalExtras;
    }
    
    /**
     * @return the totalNocturno
     */
    public Double getTotalNocturno() {
        return totalNocturno;
    }
    
    /**
     * @param totalNocturno the totalNocturno to set
     */
    public void setTotalNocturno(Double totalNocturno) {
        this.totalNocturno = totalNocturno;
    }
    
    /**
     * @return the totalAntiguedad
     */
    public Double getTotalAntiguedad() {
        return totalAntiguedad;
    }
    
    /**
     * @param totalAntiguedad the totalAntiguedad to set
     */
    public void setTotalAntiguedad(Double totalAntiguedad) {
        this.totalAntiguedad = totalAntiguedad;
    }
    
    /**
     * @return the totalParcial
     */
    public Double getTotalParcial() {
        return totalParcial;
    }
    
    /**
     * @param totalParcial the totalParcial to set
     */
    public void setTotalParcial(Double totalParcial) {
        this.totalParcial = totalParcial;
    }
    
    /**
     * @return the promedioIndemnizable
     */
    public Double getPromedioIndemnizable() {
        return promedioIndemnizable;
    }
    
    /**
     * @param promedioIndemnizable the promedioIndemnizable to set
     */
    public void setPromedioIndemnizable(Double promedioIndemnizable) {
        this.promedioIndemnizable = promedioIndemnizable;
    }
    
    /**
     * @return the beneficios
     */
    public BeneficioFiniquito getBeneficios() {
        return beneficios;
    }
    
    /**
     * @param beneficios the beneficios to set
     */
    public void setBeneficios(BeneficioFiniquito beneficios) {
        this.beneficios = beneficios;
    }
    
    /**
     * @return the importePagable
     */
    public Double getImportePagable() {
        return importePagable;
    }
    
    /**
     * @param importePagable the importePagable to set
     */
    public void setImportePagable(Double importePagable) {
        this.importePagable = importePagable;
    }

    public int getAnioServicio() {
        return anioServicio;
    }

    public void setAnioServicio(int anioServicio) {
        this.anioServicio = anioServicio;
    }

    public int getMesServicio() {
        return mesServicio;
    }

    public void setMesServicio(int mesServicio) {
        this.mesServicio = mesServicio;
    }

    public int getDiaServicio() {
        return diaServicio;
    }

    public void setDiaServicio(int diaServicio) {
        this.diaServicio = diaServicio;
    }

    /**
     * @return the pago_efectivo
     */
    public String getPago_efectivo() {
        return pago_efectivo;
    }

    /**
     * @param pago_efectivo the pago_efectivo to set
     */
    public void setPago_efectivo(String pago_efectivo) {
        this.pago_efectivo = pago_efectivo;
    }

    /**
     * @return the pago_cheque
     */
    public String getPago_cheque() {
        return pago_cheque;
    }

    /**
     * @param pago_cheque the pago_cheque to set
     */
    public void setPago_cheque(String pago_cheque) {
        this.pago_cheque = pago_cheque;
    }

    /**
     * @return the numero_cheque
     */
    public String getNumero_cheque() {
        return numero_cheque;
    }

    /**
     * @param numero_cheque the numero_cheque to set
     */
    public void setNumero_cheque(String numero_cheque) {
        this.numero_cheque = numero_cheque;
    }

    /**
     * @return the nombre_banco
     */
    public String getNombre_banco() {
        return nombre_banco;
    }

    /**
     * @param nombre_banco the nombre_banco to set
     */
    public void setNombre_banco(String nombre_banco) {
        this.nombre_banco = nombre_banco;
    }

    /**
     * @return the cod_personal
     */
    public String getCod_personal() {
        return cod_personal;
    }

    /**
     * @param cod_personal the cod_personal to set
     */
    public void setCod_personal(String cod_personal) {
        this.cod_personal = cod_personal;
    }

    /**
     * @return the monto_pago
     */
    public Double getMonto_pago() {
        return monto_pago;
    }

    /**
     * @param monto_pago the monto_pago to set
     */
    public void setMonto_pago(Double monto_pago) {
        this.monto_pago = monto_pago;
    }

    /**
     * @return the monto_pago_literal
     */
    public String getMonto_pago_literal() {
        return monto_pago_literal;
    }

    /**
     * @param monto_pago_literal the monto_pago_literal to set
     */
    public void setMonto_pago_literal(String monto_pago_literal) {
        this.monto_pago_literal = monto_pago_literal;
    }

    /**
     * @return the dias_ultimo_salario
     */
    public int getDias_ultimo_salario() {
        return dias_ultimo_salario;
    }

    /**
     * @param dias_ultimo_salario the dias_ultimo_salario to set
     */
    public void setDias_ultimo_salario(int dias_ultimo_salario) {
        this.dias_ultimo_salario = dias_ultimo_salario;
    }

    /**
     * @return the monto_ultimo_salario
     */
    public Double getMonto_ultimo_salario() {
        return monto_ultimo_salario;
    }

    /**
     * @param monto_ultimo_salario the monto_ultimo_salario to set
     */
    public void setMonto_ultimo_salario(Double monto_ultimo_salario) {
        this.monto_ultimo_salario = monto_ultimo_salario;
    }

    /**
     * @return the nombreAreaEmpresa
     */
    public String getNombreAreaEmpresa() {
        return nombreAreaEmpresa;
    }

    /**
     * @param nombreAreaEmpresa the nombreAreaEmpresa to set
     */
    public void setNombreAreaEmpresa(String nombreAreaEmpresa) {
        this.nombreAreaEmpresa = nombreAreaEmpresa;
    }


}
