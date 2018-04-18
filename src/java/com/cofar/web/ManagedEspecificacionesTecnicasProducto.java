/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.EspecificacionesTecnicas;
import com.cofar.bean.EspecificacionesTecnicasPresentacion;
import com.cofar.bean.EspecificacionesTiposCotizaciones;
import com.cofar.bean.PresentacionesProducto;
import com.cofar.bean.TiposEspecificacionesTecnicas;

import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.faces.model.SelectItem;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author aquispe
 */

public class ManagedEspecificacionesTecnicasProducto extends ManagedBean{

    private Connection con=null;
    private List<TiposEspecificacionesTecnicas> tiposEspecificacionesTecnicasList=new ArrayList<TiposEspecificacionesTecnicas>();
    private TiposEspecificacionesTecnicas tiposEspecificacionesTecnicasAgregar=new TiposEspecificacionesTecnicas();
    private TiposEspecificacionesTecnicas tiposEspecificacionesTecnicasEditar=new TiposEspecificacionesTecnicas();
    private String mensaje="";
    private List<EspecificacionesTecnicas > especificacionesTecnicasList=new ArrayList<EspecificacionesTecnicas>();
    private EspecificacionesTecnicas especificacionesTecnicasAgregar=new EspecificacionesTecnicas();
    private EspecificacionesTecnicas especificacionesTecnicasEditar=new EspecificacionesTecnicas();
    private EspecificacionesTecnicas especificacionesTecnicasBean=new EspecificacionesTecnicas();
    private List<SelectItem> tiposEspecificacionesSelectList=new ArrayList<SelectItem>();
    private EspecificacionesTiposCotizaciones especificacionesTiposCotizacionesBean=new EspecificacionesTiposCotizaciones();
    private List<EspecificacionesTiposCotizaciones> especificacionesTiposCotizacionesList=new ArrayList<EspecificacionesTiposCotizaciones>();
    private List<SelectItem> tiposCotizacionesSelectList=new ArrayList<SelectItem>();
    private List<EspecificacionesTecnicas> especificacionesTecnicasAgregarList=new ArrayList<EspecificacionesTecnicas>();
    private List<PresentacionesProducto> presentacionesProductoList=new ArrayList<PresentacionesProducto>();
    private PresentacionesProducto presentacionesProductoBean=new PresentacionesProducto();
    private List<SelectItem> tiposProgramaProdSelectList=new ArrayList<SelectItem>();
    private PresentacionesProducto presentacionesProductoRegistrarFicha=new PresentacionesProducto();
    private HtmlDataTable presentacionesDataTable=new HtmlDataTable();
    private List<TiposEspecificacionesTecnicas> especificacionesTecnicasPresentacionList=new ArrayList<TiposEspecificacionesTecnicas>();
    private String codTipoCotizacion="";
    /** Creates a new instance of ManagedEspecificacionesTecnicasProducto */
    public ManagedEspecificacionesTecnicasProducto() {
    }
    public String seleccionPresentacionFichaTecnica()
    {
        presentacionesProductoRegistrarFicha=(PresentacionesProducto)presentacionesDataTable.getRowData();
        return null;
    }
    public String buscarPresentacionProducto_action()
    {
        this.cargarPresentacionesProducto();
        return null;
    }
    
    public String getCargarPresentacionesProducto()
    {
        presentacionesProductoBean.getTiposProgramaProduccion().setCodTipoProgramaProd("0");
        presentacionesProductoBean.getEstadoReferencial().setCodEstadoRegistro("1");
        this.cargarTiposProgramaProduccion();
        this.cargarPresentacionesProducto();
        return null;
    }
    private void cargarTiposProgramaProduccion()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta=" select tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD "+
                            " from TIPOS_PROGRAMA_PRODUCCION tpp where tpp.COD_ESTADO_REGISTRO=1 order by tpp.NOMBRE_TIPO_PROGRAMA_PROD";
            ResultSet res=st.executeQuery(consulta);
            tiposProgramaProdSelectList.clear();
            while(res.next())
            {
                tiposProgramaProdSelectList.add(new SelectItem(res.getString("COD_TIPO_PROGRAMA_PROD"),res.getString("NOMBRE_TIPO_PROGRAMA_PROD")));
            }
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarPresentacionesProducto()
    {
       try
       {
           con=Util.openConnection(con);
           String consulta="select pp.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION,pp.OBS_PRESENTACION" +
                           " ,tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD" +
                           " ,er.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO"+
                           " from PRESENTACIONES_PRODUCTO pp inner join TIPOS_PROGRAMA_PRODUCCION tpp"+
                           " on pp.COD_TIPO_PROGRAMA_PROD=tpp.COD_TIPO_PROGRAMA_PROD" +
                           " inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=pp.cod_estado_registro"+
                           " where 1=1 " +
                           (presentacionesProductoBean.getTiposProgramaProduccion().getCodTipoProgramaProd().equals("0")?"":" and  pp.COD_TIPO_PROGRAMA_PROD='"+presentacionesProductoBean.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'")+
                           (presentacionesProductoBean.getEstadoReferencial().getCodEstadoRegistro().equals("0")?"":" and pp.cod_estado_registro='"+presentacionesProductoBean.getEstadoReferencial().getCodEstadoRegistro()+"'")+
                           " order by pp.NOMBRE_PRODUCTO_PRESENTACION";
           System.out.println("consulta cargar presentaciones productos "+consulta);
           Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
           ResultSet res=st.executeQuery(consulta);
           presentacionesProductoList.clear();
           while(res.next())
           {
               PresentacionesProducto nuevo=new PresentacionesProducto();
               nuevo.setCodPresentacion(res.getString("cod_presentacion"));
               nuevo.setNombreProductoPresentacion(res.getString("NOMBRE_PRODUCTO_PRESENTACION"));
               nuevo.setObsPresentacion(res.getString("OBS_PRESENTACION"));
               nuevo.getTiposProgramaProduccion().setCodTipoProgramaProd(res.getString("COD_TIPO_PROGRAMA_PROD"));
               nuevo.getTiposProgramaProduccion().setNombreTipoProgramaProd(res.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
               nuevo.getEstadoReferencial().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
               nuevo.getEstadoReferencial().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
               presentacionesProductoList.add(nuevo);
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

    private void cargarTiposCotizacionesSelect()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select tcv.COD_TIPOCOTIZACION,tcv.NOMBRE_TIPOCOTIZACION from TIPOS_COTIZACIONES_VENTAS tcv where tcv.COD_ESTADO_REGISTRO=1 order by tcv.NOMBRE_TIPOCOTIZACION";
            ResultSet res=st.executeQuery(consulta);
            tiposCotizacionesSelectList.clear();
            while(res.next())
            {
                tiposCotizacionesSelectList.add(new SelectItem(res.getInt("COD_TIPOCOTIZACION"),res.getString("NOMBRE_TIPOCOTIZACION")));
            }
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String especificacionesTiposEspecificaciones_change()
    {
        this.cargarEspecificacionesTiposCotizaciones();
        return null;
    }
    public String getCargarEspecificacionesTecnicasPresentacion()
    {
        this.cargarEspecificacionesTecnicasPresentacion();
        return null;
    }
    private void cargarEspecificacionesTecnicasPresentacion()
    {
        codTipoCotizacion=Util.getParameter("codTipoCotizacion");
        try
        {
            con=Util.openConnection(con);
            String consulta="select et.NOMBRE_ESPECIFICACION_TECNICA,tet.NOMBRE_TIPO_ESPECIFICACION_TECNICA,tet.COD_TIPO_ESPECIFICACION_TECNICA,"+
                            " et.COD_ESPECIFICACION_TECNICA,isnull(etp.DETALLE_ESPECIFICACION_TECNICA,'') as DETALLE_ESPECIFICACION_TECNICA,"+
                            " etp.COD_TIPO_COTIZACION"+
                            " from ESPECIFICACIONES_TIPOS_COTIZACIONES etc inner join ESPECIFICACIONES_TECNICAS et"+
                            " on etc.COD_ESPECIFICACION_TECNICA=et.COD_ESPECIFICACION_TECNICA"+
                            " inner join TIPOS_ESPECIFICACIONES_TECNICAS tet on tet.COD_TIPO_ESPECIFICACION_TECNICA="+
                            " et.COD_TIPO_ESPECIFICACION_TECNICA"+
                            " left outer join ESPECIFICACIONES_TECNICAS_PRESENTACION etp on etp.COD_TIPO_COTIZACION=etc.COD_TIPOCOTIZACION"+
                            " and et.COD_ESPECIFICACION_TECNICA=etp.COD_ESPECIFICACION_TECNICA"+
                            " and etp.COD_PRESENTACION='"+presentacionesProductoRegistrarFicha.getCodPresentacion()+"'"+
                            " where etc.COD_TIPOCOTIZACION='"+codTipoCotizacion+"'"+
                            " order by tet.NOMBRE_TIPO_ESPECIFICACION_TECNICA,et.NOMBRE_ESPECIFICACION_TECNICA";
            System.out.println("consulta cargar especificaciones tecnicas "+consulta);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            TiposEspecificacionesTecnicas nuevo=new TiposEspecificacionesTecnicas();
            especificacionesTecnicasPresentacionList.clear();
            List<EspecificacionesTecnicasPresentacion> lista=new ArrayList<EspecificacionesTecnicasPresentacion>();
            while(res.next())
            {
                if(nuevo.getCodTipoEspecificacionTecnica()!=res.getInt("COD_TIPO_ESPECIFICACION_TECNICA"))
                {
                    if(nuevo.getCodTipoEspecificacionTecnica()>0)
                    {
                        
                        nuevo.setEspecificacionesTecnicasPresentacionesList(lista);
                        especificacionesTecnicasPresentacionList.add(nuevo);
                    }
                    nuevo=new TiposEspecificacionesTecnicas();
                    nuevo.setCodTipoEspecificacionTecnica(res.getInt("COD_TIPO_ESPECIFICACION_TECNICA"));
                    nuevo.setNombreTipoEspecificacionTecnica(res.getString("NOMBRE_TIPO_ESPECIFICACION_TECNICA"));
                    lista=new ArrayList<EspecificacionesTecnicasPresentacion>();
                }
                EspecificacionesTecnicasPresentacion detalle=new EspecificacionesTecnicasPresentacion();
                detalle.setDetalleEspecificacionTecnica(res.getString("DETALLE_ESPECIFICACION_TECNICA"));
                detalle.getTiposCotizacionesVentas().setCodTipoCotizacion(res.getInt("COD_TIPO_COTIZACION"));
                detalle.getEspecificacionesTecnicas().setCodEspecificacionTecnica(res.getInt("COD_ESPECIFICACION_TECNICA"));
                detalle.getEspecificacionesTecnicas().setNombreEspecificacionTecnica(res.getString("NOMBRE_ESPECIFICACION_TECNICA"));
                lista.add(detalle);
            }
            if(nuevo.getCodTipoEspecificacionTecnica()>0)
            {
                nuevo.setEspecificacionesTecnicasPresentacionesList(lista);
                especificacionesTecnicasPresentacionList.add(nuevo);
            }
            System.out.println(especificacionesTecnicasPresentacionList.size());
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String guardarEspecificacionesTecnicasPresentaciones_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta="delete ESPECIFICACIONES_TECNICAS_PRESENTACION  where COD_PRESENTACION='"+presentacionesProductoRegistrarFicha.getCodPresentacion()+"' and COD_TIPO_COTIZACION='"+codTipoCotizacion+"'";
            System.out.println("consulta delete anteriiores esp "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
            for(TiposEspecificacionesTecnicas bean:especificacionesTecnicasPresentacionList)
            {
                for(EspecificacionesTecnicasPresentacion registro:bean.getEspecificacionesTecnicasPresentacionesList())
                {
                    consulta="INSERT INTO ESPECIFICACIONES_TECNICAS_PRESENTACION(COD_PRESENTACION,"+
                             " COD_ESPECIFICACION_TECNICA, DETALLE_ESPECIFICACION_TECNICA, COD_TIPO_COTIZACION)"+
                             " VALUES ('"+presentacionesProductoRegistrarFicha.getCodPresentacion()+"','"+registro.getEspecificacionesTecnicas().getCodEspecificacionTecnica()+"',"+
                                "'"+registro.getDetalleEspecificacionTecnica()+"', '"+codTipoCotizacion+"')";
                    System.out.println("consulta insert detalle "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el detalle");
                }
            }
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de registrar la propuesta,intente de nuevo";
            ex.printStackTrace();
        }
        return null;
    }
    public String getCargarEspecificacionesTiposCotizaciones()
    {
        this.cargarTiposCotizacionesSelect();
        this.cargarTiposEspecificacionesTecnicasSelect();
        especificacionesTiposCotizacionesBean.getTiposCotizacionesVentas().setCodTipoCotizacion(Integer.valueOf(tiposCotizacionesSelectList.get(0).getValue().toString()));
        this.cargarEspecificacionesTiposCotizaciones();
        return null;
    }
    public String guardarEspecificacionesTecnicasTiposCotizaciones_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta="";
            PreparedStatement pst=null;
            for(EspecificacionesTecnicas bean:especificacionesTecnicasAgregarList)
            {
                if(bean.getChecked())
                {
                    consulta="INSERT INTO ESPECIFICACIONES_TIPOS_COTIZACIONES(COD_TIPOCOTIZACION,"+
                            " COD_ESPECIFICACION_TECNICA)"+
                            " VALUES ('"+especificacionesTiposCotizacionesBean.getTiposCotizacionesVentas().getCodTipoCotizacion()+"'" +
                            ",'"+bean.getCodEspecificacionTecnica()+"')";
                    System.out.println("consulsta insert especificacion "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el tipo de especificacion ");
                }
            }
            con.commit();
            mensaje="1";
            if(pst!=null)pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de registrar la(s) especificacion(es),intente de nuevo";
            con.rollback();
            con.close();
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarEspecificacionesTiposCotizaciones();
        }
        return null;
    }
    public String cargarEspecificacionesTecnicasAgregar_action()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String codigos="";
            for(EspecificacionesTiposCotizaciones bean:especificacionesTiposCotizacionesList)
            {
                codigos+=(codigos.equals("")?"":",")+bean.getEspecificacionesTecnicas().getCodEspecificacionTecnica();
            }
            String consulta="select et.COD_ESPECIFICACION_TECNICA,et.NOMBRE_ESPECIFICACION_TECNICA,"+
                            " tec.NOMBRE_TIPO_ESPECIFICACION_TECNICA"+
                            " from ESPECIFICACIONES_TECNICAS et inner join TIPOS_ESPECIFICACIONES_TECNICAS tec"+
                            " on et.COD_TIPO_ESPECIFICACION_TECNICA=tec.COD_TIPO_ESPECIFICACION_TECNICA"+
                            " where et.COD_ESTADO_REGISTRO=1"+
                            (especificacionesTiposCotizacionesBean.getEspecificacionesTecnicas().getTiposEspecificacionesTecnica().getCodTipoEspecificacionTecnica()==0?
                                "":" and tec.COD_TIPO_ESPECIFICACION_TECNICA='"+especificacionesTiposCotizacionesBean.getEspecificacionesTecnicas().getTiposEspecificacionesTecnica().getCodTipoEspecificacionTecnica()+"'")+
                            (codigos.equals("")?"": " and et.COD_ESPECIFICACION_TECNICA not in ("+codigos+")")+
                            " order by et.NOMBRE_ESPECIFICACION_TECNICA";
            System.out.println("consulta especificaciones tecnicas agregar "+consulta);
            ResultSet res=st.executeQuery(consulta);
            especificacionesTecnicasAgregarList.clear();
            while(res.next())
            {
                EspecificacionesTecnicas nuevo=new EspecificacionesTecnicas();
                nuevo.setCodEspecificacionTecnica(res.getInt("COD_ESPECIFICACION_TECNICA"));
                nuevo.setNombreEspecificacionTecnica(res.getString("NOMBRE_ESPECIFICACION_TECNICA"));
                nuevo.getTiposEspecificacionesTecnica().setNombreTipoEspecificacionTecnica(res.getString("NOMBRE_TIPO_ESPECIFICACION_TECNICA"));
                especificacionesTecnicasAgregarList.add(nuevo);
            }
            st.close();
            con.close();

        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return null;
    }
    public String eliminarEspecificacionesTiposCotizacion_action()throws SQLException
    {
        mensaje="";
        for(EspecificacionesTiposCotizaciones bean:especificacionesTiposCotizacionesList)
        {
            if(bean.getChecked())
            {
                try
                {
                    con=Util.openConnection(con);
                    con.setAutoCommit(false);
                    String consulta="delete ESPECIFICACIONES_TIPOS_COTIZACIONES where"+
                                    " COD_ESPECIFICACION_TECNICA='"+bean.getEspecificacionesTecnicas().getCodEspecificacionTecnica()+"'"+
                                    " and COD_TIPOCOTIZACION='"+especificacionesTiposCotizacionesBean.getTiposCotizacionesVentas().getCodTipoCotizacion()+"'";
                    System.out.println("consulta delete etc "+consulta);
                    PreparedStatement pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se elimino la especificacion ");
                    con.commit();
                    mensaje="1";
                    pst.close();
                    con.close();
                }
                catch(SQLException ex)
                {
                    mensaje="Ocurrio un error al momento de eliminar la especificacion,intente de nuevo";
                    con.rollback();
                    con.close();
                    ex.printStackTrace();
                }
            }
        }
        
        if(mensaje.equals("1"))
        {
            this.cargarEspecificacionesTiposCotizaciones();
        }
        return null;
    }
    private void cargarEspecificacionesTiposCotizaciones()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select  etc.COD_TIPOCOTIZACION,et.COD_ESPECIFICACION_TECNICA,et.NOMBRE_ESPECIFICACION_TECNICA" +
                            ",et.COD_TIPO_ESPECIFICACION_TECNICA,tec.NOMBRE_TIPO_ESPECIFICACION_TECNICA"+
                            " from ESPECIFICACIONES_TIPOS_COTIZACIONES etc inner join "+
                            " ESPECIFICACIONES_TECNICAS et on etc.COD_ESPECIFICACION_TECNICA=et.COD_ESPECIFICACION_TECNICA" +
                            " inner join TIPOS_ESPECIFICACIONES_TECNICAS tec on "+
                            " tec.COD_TIPO_ESPECIFICACION_TECNICA=et.COD_TIPO_ESPECIFICACION_TECNICA"+
                            " where etc.COD_TIPOCOTIZACION='"+especificacionesTiposCotizacionesBean.getTiposCotizacionesVentas().getCodTipoCotizacion()+"'"+
                            (especificacionesTiposCotizacionesBean.getEspecificacionesTecnicas().getTiposEspecificacionesTecnica().getCodTipoEspecificacionTecnica()==0?
                                " ":" and et.COD_TIPO_ESPECIFICACION_TECNICA='"+especificacionesTiposCotizacionesBean.getEspecificacionesTecnicas().getTiposEspecificacionesTecnica().getCodTipoEspecificacionTecnica()+"'")+
                                " order by  et.NOMBRE_ESPECIFICACION_TECNICA ";
            System.out.println("consulta cargar EspecificacionesTiposCotizaciones "+consulta);
            ResultSet res=st.executeQuery(consulta);
            especificacionesTiposCotizacionesList.clear();
            while(res.next())
            {
                EspecificacionesTiposCotizaciones nuevo=new EspecificacionesTiposCotizaciones();
                nuevo.getEspecificacionesTecnicas().setCodEspecificacionTecnica(res.getInt("COD_ESPECIFICACION_TECNICA"));
                nuevo.getEspecificacionesTecnicas().setNombreEspecificacionTecnica(res.getString("NOMBRE_ESPECIFICACION_TECNICA"));
                nuevo.getEspecificacionesTecnicas().getTiposEspecificacionesTecnica().setCodTipoEspecificacionTecnica(res.getInt("COD_TIPO_ESPECIFICACION_TECNICA"));
                nuevo.getEspecificacionesTecnicas().getTiposEspecificacionesTecnica().setNombreTipoEspecificacionTecnica(res.getString("NOMBRE_TIPO_ESPECIFICACION_TECNICA"));
                nuevo.getTiposCotizacionesVentas().setCodTipoCotizacion(res.getInt("COD_TIPOCOTIZACION"));
                especificacionesTiposCotizacionesList.add(nuevo);
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
    private void cargarTipoEspecificacionesTecnicas()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select  tet.COD_TIPO_ESPECIFICACION_TECNICA,tet.NOMBRE_TIPO_ESPECIFICACION_TECNICA,"+
                            " er.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO"+
                            " from TIPOS_ESPECIFICACIONES_TECNICAS tet inner join ESTADOS_REFERENCIALES er"+
                            " on er.COD_ESTADO_REGISTRO=tet.COD_ESTADO_REGISTRO"+
                            " order by tet.NOMBRE_TIPO_ESPECIFICACION_TECNICA";
            System.out.println("consulta cargar tipos esp tec "+consulta);
            ResultSet res=st.executeQuery(consulta);
            tiposEspecificacionesTecnicasList.clear();
            while(res.next())
            {
                TiposEspecificacionesTecnicas nuevo=new TiposEspecificacionesTecnicas();
                nuevo.setCodTipoEspecificacionTecnica(res.getInt("COD_TIPO_ESPECIFICACION_TECNICA"));
                nuevo.setNombreTipoEspecificacionTecnica(res.getString("NOMBRE_TIPO_ESPECIFICACION_TECNICA"));
                nuevo.getEstadoRegistro().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                nuevo.getEstadoRegistro().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                tiposEspecificacionesTecnicasList.add(nuevo);
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
    public String agregarTipoEspecificacionTecnica_action()
    {
        tiposEspecificacionesTecnicasAgregar=new TiposEspecificacionesTecnicas();
        return null;
    }
    public String guardarNuevoTipoEspecificacionTecnica_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select isnull(max(t.COD_TIPO_ESPECIFICACION_TECNICA),0)+1 as codt from TIPOS_ESPECIFICACIONES_TECNICAS t";
            String codTipoEspecificacionT="";

            ResultSet res=st.executeQuery(consulta);
            if(res.next())
            {
                codTipoEspecificacionT=res.getString("codt");
            }
            consulta="INSERT INTO TIPOS_ESPECIFICACIONES_TECNICAS(COD_TIPO_ESPECIFICACION_TECNICA,"+
                            " NOMBRE_TIPO_ESPECIFICACION_TECNICA, COD_ESTADO_REGISTRO)"+
                            " VALUES ('"+codTipoEspecificacionT+"','"+tiposEspecificacionesTecnicasAgregar.getNombreTipoEspecificacionTecnica()+"',"+
                            "1)";
            System.out.println("consulta insert "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro el tipo de especificacion tecnica");
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento del registro, intente de nuevo";
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarTipoEspecificacionesTecnicas();
        }
        return null;
    }
    public String editarTiposEspecificacionesTecnicas_action()
    {
        for(TiposEspecificacionesTecnicas bean:tiposEspecificacionesTecnicasList)
        {
            if(bean.getChecked())
            {
                tiposEspecificacionesTecnicasEditar=bean;
            }
        }
        return null;
    }
    public String guardarEdicionTiposEspecificacionesTecnicas_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta="UPDATE TIPOS_ESPECIFICACIONES_TECNICAS"+
                            " SET NOMBRE_TIPO_ESPECIFICACION_TECNICA = '"+tiposEspecificacionesTecnicasEditar.getNombreTipoEspecificacionTecnica()+"',"+
                            " COD_ESTADO_REGISTRO = '"+tiposEspecificacionesTecnicasEditar.getEstadoRegistro().getCodEstadoRegistro()+"'"+
                            " WHERE COD_TIPO_ESPECIFICACION_TECNICA = '"+tiposEspecificacionesTecnicasEditar.getCodTipoEspecificacionTecnica()+"'";
            System.out.println("consulta update tpt "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("Se modifico el tipo de especificacion");
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de guardar la edicion, intente de nuevo";
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarTipoEspecificacionesTecnicas();
        }
        return null;
    }
    public String eliminarTiposEspecificacionesTecnicas_action()throws SQLException
    {
        mensaje="";
        for(TiposEspecificacionesTecnicas bean:tiposEspecificacionesTecnicasList)
        {
            if(bean.getChecked())
            {
                try
                {
                    con=Util.openConnection(con);
                    con.setAutoCommit(false);
                    String consulta="delete TIPOS_ESPECIFICACIONES_TECNICAS"+
                                    " where COD_TIPO_ESPECIFICACION_TECNICA ='"+bean.getCodTipoEspecificacionTecnica()+"'";
                    System.out.println("consulta delete tipos es t "+consulta);
                    PreparedStatement pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se elimino el tipo de especificacion tecnica");
                    con.commit();
                    mensaje="1";
                    pst.close();
                    con.close();
                }
                catch(SQLException ex)
                {
                    ex.printStackTrace();
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarTipoEspecificacionesTecnicas();
        }
        return null;
    }
    private void cargarEspecificacionesTecnicas()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select et.NOMBRE_ESPECIFICACION_TECNICA,et.COD_ESPECIFICACION_TECNICA,"+
                            " tet.COD_TIPO_ESPECIFICACION_TECNICA,tet.NOMBRE_TIPO_ESPECIFICACION_TECNICA,"+
                            " er.COD_ESTADO_REGISTRO,er.NOMBRE_ESTADO_REGISTRO"+
                            " from ESPECIFICACIONES_TECNICAS et inner join TIPOS_ESPECIFICACIONES_TECNICAS tet"+
                            " on et.COD_TIPO_ESPECIFICACION_TECNICA=tet.COD_TIPO_ESPECIFICACION_TECNICA"+
                            " inner join ESTADOS_REFERENCIALES er on er.COD_ESTADO_REGISTRO=et.COD_ESTADO_REGISTRO"+
                            (especificacionesTecnicasBean.getTiposEspecificacionesTecnica().getCodTipoEspecificacionTecnica()>0?" where tet.COD_TIPO_ESPECIFICACION_TECNICA='"+especificacionesTecnicasBean.getTiposEspecificacionesTecnica().getCodTipoEspecificacionTecnica()+"'":"")+
                            " order by et.NOMBRE_ESPECIFICACION_TECNICA";
            System.out.println("consulta cargar especificaciones tecnicas "+consulta);
            ResultSet res=st.executeQuery(consulta);
            especificacionesTecnicasList.clear();
            while(res.next())
            {
                EspecificacionesTecnicas nuevo=new EspecificacionesTecnicas();
                nuevo.setCodEspecificacionTecnica(res.getInt("COD_ESPECIFICACION_TECNICA"));
                nuevo.setNombreEspecificacionTecnica(res.getString("NOMBRE_ESPECIFICACION_TECNICA"));
                nuevo.getTiposEspecificacionesTecnica().setCodTipoEspecificacionTecnica(res.getInt("COD_TIPO_ESPECIFICACION_TECNICA"));
                nuevo.getTiposEspecificacionesTecnica().setNombreTipoEspecificacionTecnica(res.getString("NOMBRE_TIPO_ESPECIFICACION_TECNICA"));
                nuevo.getEstadoRegistro().setCodEstadoRegistro(res.getString("COD_ESTADO_REGISTRO"));
                nuevo.getEstadoRegistro().setNombreEstadoRegistro(res.getString("NOMBRE_ESTADO_REGISTRO"));
                especificacionesTecnicasList.add(nuevo);
            }
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String agregarEspecificacionTecnica_action()
    {
        especificacionesTecnicasAgregar=new EspecificacionesTecnicas();
        especificacionesTecnicasAgregar.getTiposEspecificacionesTecnica().setCodTipoEspecificacionTecnica(
        especificacionesTecnicasBean.getTiposEspecificacionesTecnica().getCodTipoEspecificacionTecnica());
        return null;
    }
    public String guardarNuevaEspecificacionTecnica_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select ISNULL(max(et.COD_ESPECIFICACION_TECNICA),0)+1 as code from ESPECIFICACIONES_TECNICAS et";
            ResultSet res=st.executeQuery(consulta);
            String codEspecificacionT="";
            if(res.next())
            {
                codEspecificacionT=res.getString("code");
            }
            consulta="INSERT INTO ESPECIFICACIONES_TECNICAS(COD_ESPECIFICACION_TECNICA,"+
                     " NOMBRE_ESPECIFICACION_TECNICA, COD_TIPO_ESPECIFICACION_TECNICA,"+
                     " COD_ESTADO_REGISTRO)"+
                     " VALUES ('"+codEspecificacionT+"','"+especificacionesTecnicasAgregar.getNombreEspecificacionTecnica()+"',"+
                     " '"+especificacionesTecnicasAgregar.getTiposEspecificacionesTecnica().getCodTipoEspecificacionTecnica()+"', 1)";
            System.out.println("consulta insert "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro la especificacion tecnica");
            con.commit();
            mensaje="1";
            pst.close();
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de guardar la especificacion, intente de nuevo";
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarEspecificacionesTecnicas();
        }
        return null;
    }
    public String editarEspecificacionTecnica_action()
    {
        for(EspecificacionesTecnicas bean:especificacionesTecnicasList)
        {
            if(bean.getChecked())
            {
                especificacionesTecnicasEditar=bean;
            }
        }
        return null;
    }
    public String guardarEdicionEspecificacionesTecnicas_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            String consulta="UPDATE ESPECIFICACIONES_TECNICAS"+
                            " SET NOMBRE_ESPECIFICACION_TECNICA = '"+especificacionesTecnicasEditar.getNombreEspecificacionTecnica()+"',"+
                            "  COD_TIPO_ESPECIFICACION_TECNICA = '"+especificacionesTecnicasEditar.getTiposEspecificacionesTecnica().getCodTipoEspecificacionTecnica()+"',"+
                            " COD_ESTADO_REGISTRO = '"+especificacionesTecnicasEditar.getEstadoRegistro().getCodEstadoRegistro()+"'"+
                            " WHERE COD_ESPECIFICACION_TECNICA = '"+especificacionesTecnicasEditar.getCodEspecificacionTecnica()+"'";
            System.out.println("consulta update especificaciones tecniiicas "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se actualizaron las especificaciones tecnicas");
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de guardar la edicion, intente de nuevo";
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarEspecificacionesTecnicas();
        }
        return null;
    }
    public String getCargarTiposEspecificacionesTecnicas()
    {
        this.cargarTipoEspecificacionesTecnicas();
        return null;
    }
    public String getCargarEspecificacionesTecnicas()
    {
        especificacionesTecnicasBean.getTiposEspecificacionesTecnica().setCodTipoEspecificacionTecnica(0);
        this.cargarTiposEspecificacionesTecnicasSelect();
        this.cargarEspecificacionesTecnicas();
        return null;
    }
    public String tipoEspecificacionTecnica_change()
    {
        this.cargarEspecificacionesTecnicas();
        return null;
    }
    private void cargarTiposEspecificacionesTecnicasSelect()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select  tet.COD_TIPO_ESPECIFICACION_TECNICA,tet.NOMBRE_TIPO_ESPECIFICACION_TECNICA"+
                            " from TIPOS_ESPECIFICACIONES_TECNICAS tet where tet.COD_ESTADO_REGISTRO=1 order by tet.NOMBRE_TIPO_ESPECIFICACION_TECNICA";
            ResultSet res=st.executeQuery(consulta);
            tiposEspecificacionesSelectList.clear();
            while(res.next())
            {
                tiposEspecificacionesSelectList.add(new SelectItem(res.getInt("COD_TIPO_ESPECIFICACION_TECNICA"),res.getString("NOMBRE_TIPO_ESPECIFICACION_TECNICA")));
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
    public String eliminarEspecificacionesTecnicas_action()throws SQLException
    {
        mensaje="";
        for(EspecificacionesTecnicas bean:especificacionesTecnicasList)
        {
            if(bean.getChecked())
            {
                try
                {
                    con=Util.openConnection(con);
                    con.setAutoCommit(false);
                    String consulta="delete ESPECIFICACIONES_TECNICAS"+
                                    " WHERE COD_ESPECIFICACION_TECNICA = '"+bean.getCodEspecificacionTecnica()+"'";
                    System.out.println("consulta eliminar especificacion tec "+consulta);
                    PreparedStatement pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se elimino la especificacion tecnica");
                    con.commit();
                    mensaje="1";
                    pst.close();
                    con.close();
                }
                catch(SQLException ex)
                {
                    con.rollback();
                    con.close();
                    mensaje="Ocurrio un error al momento de eliminar la especificacion,intente de nuevo";
                    ex.printStackTrace();
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarEspecificacionesTecnicas();
        }
        return null;
    }

    public EspecificacionesTecnicas getEspecificacionesTecnicasAgregar() {
        return especificacionesTecnicasAgregar;
    }

    public void setEspecificacionesTecnicasAgregar(EspecificacionesTecnicas especificacionesTecnicasAgregar) {
        this.especificacionesTecnicasAgregar = especificacionesTecnicasAgregar;
    }

    public EspecificacionesTecnicas getEspecificacionesTecnicasEditar() {
        return especificacionesTecnicasEditar;
    }

    public void setEspecificacionesTecnicasEditar(EspecificacionesTecnicas especificacionesTecnicasEditar) {
        this.especificacionesTecnicasEditar = especificacionesTecnicasEditar;
    }

    public List<EspecificacionesTecnicas> getEspecificacionesTecnicasList() {
        return especificacionesTecnicasList;
    }

    public void setEspecificacionesTecnicasList(List<EspecificacionesTecnicas> especificacionesTecnicasList) {
        this.especificacionesTecnicasList = especificacionesTecnicasList;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public List<SelectItem> getTiposEspecificacionesSelectList() {
        return tiposEspecificacionesSelectList;
    }

    public void setTiposEspecificacionesSelectList(List<SelectItem> tiposEspecificacionesSelectList) {
        this.tiposEspecificacionesSelectList = tiposEspecificacionesSelectList;
    }

    public TiposEspecificacionesTecnicas getTiposEspecificacionesTecnicasAgregar() {
        return tiposEspecificacionesTecnicasAgregar;
    }

    public void setTiposEspecificacionesTecnicasAgregar(TiposEspecificacionesTecnicas tiposEspecificacionesTecnicasAgregar) {
        this.tiposEspecificacionesTecnicasAgregar = tiposEspecificacionesTecnicasAgregar;
    }

    public TiposEspecificacionesTecnicas getTiposEspecificacionesTecnicasEditar() {
        return tiposEspecificacionesTecnicasEditar;
    }

    public void setTiposEspecificacionesTecnicasEditar(TiposEspecificacionesTecnicas tiposEspecificacionesTecnicasEditar) {
        this.tiposEspecificacionesTecnicasEditar = tiposEspecificacionesTecnicasEditar;
    }

    public List<TiposEspecificacionesTecnicas> getTiposEspecificacionesTecnicasList() {
        return tiposEspecificacionesTecnicasList;
    }

    public void setTiposEspecificacionesTecnicasList(List<TiposEspecificacionesTecnicas> tiposEspecificacionesTecnicasList) {
        this.tiposEspecificacionesTecnicasList = tiposEspecificacionesTecnicasList;
    }

    public EspecificacionesTecnicas getEspecificacionesTecnicasBean() {
        return especificacionesTecnicasBean;
    }

    public void setEspecificacionesTecnicasBean(EspecificacionesTecnicas especificacionesTecnicasBean) {
        this.especificacionesTecnicasBean = especificacionesTecnicasBean;
    }

    public List<EspecificacionesTecnicas> getEspecificacionesTecnicasAgregarList() {
        return especificacionesTecnicasAgregarList;
    }

    public void setEspecificacionesTecnicasAgregarList(List<EspecificacionesTecnicas> especificacionesTecnicasAgregarList) {
        this.especificacionesTecnicasAgregarList = especificacionesTecnicasAgregarList;
    }

    public EspecificacionesTiposCotizaciones getEspecificacionesTiposCotizacionesBean() {
        return especificacionesTiposCotizacionesBean;
    }

    public void setEspecificacionesTiposCotizacionesBean(EspecificacionesTiposCotizaciones especificacionesTiposCotizacionesBean) {
        this.especificacionesTiposCotizacionesBean = especificacionesTiposCotizacionesBean;
    }

    public List<EspecificacionesTiposCotizaciones> getEspecificacionesTiposCotizacionesList() {
        return especificacionesTiposCotizacionesList;
    }

    public void setEspecificacionesTiposCotizacionesList(List<EspecificacionesTiposCotizaciones> especificacionesTiposCotizacionesList) {
        this.especificacionesTiposCotizacionesList = especificacionesTiposCotizacionesList;
    }

    public List<SelectItem> getTiposCotizacionesSelectList() {
        return tiposCotizacionesSelectList;
    }

    public void setTiposCotizacionesSelectList(List<SelectItem> tiposCotizacionesSelectList) {
        this.tiposCotizacionesSelectList = tiposCotizacionesSelectList;
    }

    public PresentacionesProducto getPresentacionesProductoBean() {
        return presentacionesProductoBean;
    }

    public void setPresentacionesProductoBean(PresentacionesProducto presentacionesProductoBean) {
        this.presentacionesProductoBean = presentacionesProductoBean;
    }

    public List<PresentacionesProducto> getPresentacionesProductoList() {
        return presentacionesProductoList;
    }

    public void setPresentacionesProductoList(List<PresentacionesProducto> presentacionesProductoList) {
        this.presentacionesProductoList = presentacionesProductoList;
    }

    public List<SelectItem> getTiposProgramaProdSelectList() {
        return tiposProgramaProdSelectList;
    }

    public void setTiposProgramaProdSelectList(List<SelectItem> tiposProgramaProdSelectList) {
        this.tiposProgramaProdSelectList = tiposProgramaProdSelectList;
    }

    public List<TiposEspecificacionesTecnicas> getEspecificacionesTecnicasPresentacionList() {
        return especificacionesTecnicasPresentacionList;
    }

    public void setEspecificacionesTecnicasPresentacionList(List<TiposEspecificacionesTecnicas> especificacionesTecnicasPresentacionList) {
        this.especificacionesTecnicasPresentacionList = especificacionesTecnicasPresentacionList;
    }

    public HtmlDataTable getPresentacionesDataTable() {
        return presentacionesDataTable;
    }

    public void setPresentacionesDataTable(HtmlDataTable presentacionesDataTable) {
        this.presentacionesDataTable = presentacionesDataTable;
    }

    public PresentacionesProducto getPresentacionesProductoRegistrarFicha() {
        return presentacionesProductoRegistrarFicha;
    }

    public void setPresentacionesProductoRegistrarFicha(PresentacionesProducto presentacionesProductoRegistrarFicha) {
        this.presentacionesProductoRegistrarFicha = presentacionesProductoRegistrarFicha;
    }

    public String getCodTipoCotizacion() {
        return codTipoCotizacion;
    }

    public void setCodTipoCotizacion(String codTipoCotizacion) {
        this.codTipoCotizacion = codTipoCotizacion;
    }

    

}
