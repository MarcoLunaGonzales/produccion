/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.ProgramaProduccion;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import javax.faces.model.SelectItem;

/**
 *
 * @author wchoquehuanca
 */

public class ManagedEstadosProgramaProduccion  extends ManagedBean{
    private List<SelectItem> programaPeriodoList=new ArrayList<SelectItem>();
    private List<SelectItem> estadosProgramaProdList=new ArrayList<SelectItem>();
    private String codEstado="";
    private Connection con=null;
    private String[] codProgramaProd;
    private List<ProgramaProduccion> programaProduccionList= new ArrayList<ProgramaProduccion>();
    private List<SelectItem> estadosProgramaCambiar=new ArrayList<SelectItem>();
    private ProgramaProduccion programaProduccionCambio= new ProgramaProduccion();
    private String codLoteProduccion = "";
    private String mensaje = "";
    /** Creates a new instance of ManagedEstadosProgramaProduccion */
    public ManagedEstadosProgramaProduccion() {
    }
    public String getCargarProgramasProduccion()
    {
        this.cargarCambiosEstado("6,9,8");
        this.cargarProgramasPeriodo();
        this.cargarEstadosProgramaProduccion();
        return null;
    }
    public String getCargarProgramasProduccionGI()
    {
        this.cargarCambiosEstado("8,9");
        this.cargarProgramasPeriodo();
        this.cargarEstadosProgramaProduccion();
        return null;
    }
    private void cargarEstadosProgramaProduccion()
    {
        try
        {
            String consulta="select e.COD_ESTADO_PROGRAMA_PROD,e.NOMBRE_ESTADO_PROGRAMA_PROD from ESTADOS_PROGRAMA_PRODUCCION e";
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            estadosProgramaProdList.clear();
            estadosProgramaProdList.add(new SelectItem("0", "-TODOS-"));
            while(res.next())
            {
                estadosProgramaProdList.add(new SelectItem(res.getString("COD_ESTADO_PROGRAMA_PROD"),res.getString("NOMBRE_ESTADO_PROGRAMA_PROD")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {ex.printStackTrace();
        }
    }
    private void cargarProgramasPeriodo()
    {
        try
        {
            String consulta="select pp.COD_PROGRAMA_PROD,pp.NOMBRE_PROGRAMA_PROD FROM PROGRAMA_PRODUCCION_PERIODO PP WHERE PP.COD_ESTADO_PROGRAMA<>4 and isnull(PP.COD_TIPO_PRODUCCION,1)=1";
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            programaPeriodoList.clear();
            while(res.next())
            {
                programaPeriodoList.add(new SelectItem(res.getString("COD_PROGRAMA_PROD"),res.getString("NOMBRE_PROGRAMA_PROD")));
            }
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();

        }
    }
    public String mostrarResultadosFiltroAction()
    {
        Connection con=null;
        String codigos="";
        for(int i=0;i<codProgramaProd.length;i++)
        {
            codigos+=(codigos.equals("")?"":",")+codProgramaProd[i];
        }
         String consulta = " select tpp.NOMBRE_TIPO_PROGRAMA_PROD,ppr.COD_TIPO_PROGRAMA_PROD,ppr.COD_FORMULA_MAESTRA,ppr.COD_PROGRAMA_PROD," +
                         " cp.nombre_prod_semiterminado,cp.COD_COMPPROD,pprp.NOMBRE_PROGRAMA_PROD,ppr.COD_LOTE_PRODUCCION, " +
                         "(select top 1 sppr.FECHA_INICIO  from seguimiento_programa_produccion sppr " +
                         "inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA" +
                         " and afm.COD_FORMULA_MAESTRA = sppr.COD_FORMULA_MAESTRA " +
                         " where sppr.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD " +
                         " and sppr.COD_COMPPROD = ppr.COD_COMPPROD " +
                         " and sppr.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA " +
                         " and sppr.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION " +
                         " and sppr.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD " +
                         " and afm.COD_ACTIVIDAD = 76 ) fecha_inicio, " +
                         " dateadd(MONTH,cp.VIDA_UTIL,(select top 1 sppr.FECHA_INICIO  from seguimiento_programa_produccion sppr  " +
                         " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = sppr.COD_ACTIVIDAD_PROGRAMA " +
                         " and afm.COD_FORMULA_MAESTRA = sppr.COD_FORMULA_MAESTRA " +
                         " where sppr.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD " +
                         " and sppr.COD_COMPPROD = ppr.COD_COMPPROD " +
                         " and sppr.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA " +
                         " and sppr.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION " +
                         " and sppr.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD " +
                         " and afm.COD_ACTIVIDAD = 76 )) fecha_vencimiento,e.nombre_estado_programa_prod,ppr.cant_lote_produccion,(select  " +
                         " sum( ida.cant_ingreso_produccion) from programa_produccion_ingresos_acond ppria inner join ingresos_detalleacond ida " +
                         " on ida.cod_ingreso_acond = ppria.cod_ingreso_acond and ida.cod_lote_produccion = ppria.cod_lote_produccion and ida.cod_compprod = ppria.cod_compprod " +
                         " where ppria.cod_programa_prod = ppr.cod_programa_prod and ppria.cod_compprod = ppr.cod_compprod " +
                         " and ppria.cod_lote_produccion = ppr.cod_lote_produccion " +
                         " and ppria.cod_tipo_programa_prod = ppr.cod_tipo_programa_prod " +
                         " and ppria.cod_formula_maestra = ppr.cod_formula_maestra ) cant_ingreso_produccion1,(select sum(ida.cant_total_ingreso) from ingresos_detalleacond ida where ida.cod_lote_produccion = ppr.cod_lote_produccion) cant_ingreso_produccion " +
                         " from programa_produccion ppr inner join PROGRAMA_PRODUCCION_PERIODO pprp " +
                         " on pprp.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD " +
                         " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = ppr.COD_COMPPROD " +
                         " inner join estados_programa_produccion e on e.cod_estado_programa_prod = ppr.cod_estado_programa" +
                         " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=ppr.COD_TIPO_PROGRAMA_PROD" +
                         " where 0=0 "+(!codEstado.equals("0")?" and  ppr.COD_ESTADO_PROGRAMA = '"+codEstado+"'":"")+(codigos.equals("")?"":" and pprp.cod_programa_prod in("+codigos+")")+(!codLoteProduccion.trim().equals("")?" and ppr.cod_lote_produccion='"+codLoteProduccion+"'":"")+" order by cp.nombre_prod_semiterminado asc ";
         System.out.println("consulta cargar"+consulta);
         try
         {
             con=Util.openConnection(con);
             Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             ResultSet res=st.executeQuery(consulta);
             SimpleDateFormat sdt= new SimpleDateFormat("dd/MM/yyyy");

             programaProduccionList.clear();
             while(res.next())
             {
                ProgramaProduccion bean= new ProgramaProduccion();
                bean.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                bean.getFormulaMaestra().getComponentesProd().setCodCompprod(res.getString("COD_COMPPROD"));
                bean.setCodProgramaProduccion(res.getString("COD_PROGRAMA_PROD"));
                bean.setCodLoteProduccion(res.getString("COD_LOTE_PRODUCCION"));
                bean.getFormulaMaestra().setCodFormulaMaestra(res.getString("COD_FORMULA_MAESTRA"));
                bean.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
                bean.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                bean.getProgramaProduccionPeriodo().setNombreProgramaProduccion(res.getString("NOMBRE_PROGRAMA_PROD"));
                bean.setFechaInicio(((res.getDate("fecha_inicio")==null)?"":sdt.format(res.getDate("fecha_inicio"))));
                bean.setFechaFinal(((res.getDate("fecha_vencimiento")==null)?"":sdt.format(res.getDate("fecha_vencimiento"))));
                bean.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(res.getString("nombre_estado_programa_prod"));
               // bean.setCodLoteProduccionAnterior(res.getString(""));
               // bean.setCantidadLote(res.getDouble(""));
                programaProduccionList.add(bean);
                
             }
             res.close();
             st.close();

            con.close();
         }
         catch(SQLException ex)
         {
             ex.printStackTrace();
         }

        return null;
    }
    public String getCodEstado() {
        return codEstado;
    }
    private void cargarCambiosEstado(String codEstadoPrograma)
    {
        try
        {
            String consulta="select e.COD_ESTADO_PROGRAMA_PROD,e.NOMBRE_ESTADO_PROGRAMA_PROD from ESTADOS_PROGRAMA_PRODUCCION e where e.COD_ESTADO_PROGRAMA_PROD in ("+codEstadoPrograma+")";
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            estadosProgramaCambiar.clear();
            while(res.next())
            {
                estadosProgramaCambiar.add(new SelectItem(res.getString("COD_ESTADO_PROGRAMA_PROD"),res.getString("NOMBRE_ESTADO_PROGRAMA_PROD")) );
            }

            res.close();

            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String cambiarEstadoAction()
    {
        for(ProgramaProduccion current: programaProduccionList)
        {
            if(current.getChecked())
            {
                programaProduccionCambio=current;
                return null;
            }

        }
        return null;
    }
    public String guardarCambioEstadoAction()
    {
        mensaje = "";
        try
        {
            if(this.tieneSalidasAlmacen(programaProduccionCambio) &&(programaProduccionCambio.getEstadoProgramaProduccion().getCodEstadoProgramaProd().equals("9")) ){
                mensaje = " el registro no puede cambiar de estado, tiene salidas de almacen ";
                return "";
            }
            con=Util.openConnection(con);
            // <editor-fold defaultstate="collapsed" desc="registro de log de transacciones">
                ManagedAccesoSistema usuarioModificacion=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                String consulta="exec PAA_REGISTRO_PROGRAMA_PRODUCCION_LOG ?,?,?,1,0";
                PreparedStatement pst=con.prepareStatement(consulta);
                pst.setString(1, programaProduccionCambio.getCodLoteProduccion());
                pst.setInt(2,Integer.valueOf(programaProduccionCambio.getCodProgramaProduccion()));
                pst.setInt(3,Integer.valueOf(usuarioModificacion.getUsuarioModuloBean().getCodUsuarioGlobal()));
                if(pst.executeUpdate()>0)System.out.println("se registro el log de edicion de lote");

            //</editor-fold>
            consulta="UPDATE PROGRAMA_PRODUCCION  SET  COD_ESTADO_PROGRAMA ='"+programaProduccionCambio.getEstadoProgramaProduccion().getCodEstadoProgramaProd()+"'"+
                            " WHERE COD_PROGRAMA_PROD = '"+programaProduccionCambio.getCodProgramaProduccion()+"' and "+
                            " COD_COMPPROD = '"+programaProduccionCambio.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and "+
                            " COD_FORMULA_MAESTRA = '"+programaProduccionCambio.getFormulaMaestra().getCodFormulaMaestra()+"' and "+
                            " COD_LOTE_PRODUCCION = '"+programaProduccionCambio.getCodLoteProduccion()+"' and "+
                            " COD_TIPO_PROGRAMA_PROD = '"+programaProduccionCambio.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'";
            System.out.println("consulta update "+consulta);
            
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se actualizo el estado del programa produccion");
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        this.mostrarResultadosFiltroAction();
        return  null;
    }
    public boolean tieneSalidasAlmacen(ProgramaProduccion p){
        boolean tieneSalidasAlmacen = false;
        try {
            String consulta ="select * from SALIDAS_ALMACEN s where s.COD_LOTE_PRODUCCION = '"+p.getCodLoteProduccion()+"' and s.COD_PROD = '"+p.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' and s.cod_estado_salida_almacen=1";
            System.out.println("consulta " + consulta);
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            if(rs.next()){
                tieneSalidasAlmacen = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tieneSalidasAlmacen;
    }
    public void setCodEstado(String codEstado) {
        this.codEstado = codEstado;
    }

    public List<SelectItem> getEstadosProgramaProdList() {
        return estadosProgramaProdList;
    }

    public void setEstadosProgramaProdList(List<SelectItem> estadosProgramaProdList) {
        this.estadosProgramaProdList = estadosProgramaProdList;
    }

    public List<SelectItem> getProgramaPeriodoList() {
        return programaPeriodoList;
    }

    public void setProgramaPeriodoList(List<SelectItem> programaPeriodoList) {
        this.programaPeriodoList = programaPeriodoList;
    }

    public String[] getCodProgramaProd() {
        return codProgramaProd;
    }

    public void setCodProgramaProd(String[] codProgramaProd) {
        this.codProgramaProd = codProgramaProd;
    }

    public List<ProgramaProduccion> getProgramaProduccionList() {
        return programaProduccionList;
    }

    public void setProgramaProduccionList(List<ProgramaProduccion> programaProduccionList) {
        this.programaProduccionList = programaProduccionList;
    }

    public List<SelectItem> getEstadosProgramaCambiar() {
        return estadosProgramaCambiar;
    }

    public void setEstadosProgramaCambiar(List<SelectItem> estadosProgramaCambiar) {
        this.estadosProgramaCambiar = estadosProgramaCambiar;
    }

    public ProgramaProduccion getProgramaProduccionCambio() {
        return programaProduccionCambio;
    }

    public void setProgramaProduccionCambio(ProgramaProduccion programaProduccionCambio) {
        this.programaProduccionCambio = programaProduccionCambio;
    }

    public String getCodLoteProduccion() {
        return codLoteProduccion;
    }

    public void setCodLoteProduccion(String codLoteProduccion) {
        this.codLoteProduccion = codLoteProduccion;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }
    
}
