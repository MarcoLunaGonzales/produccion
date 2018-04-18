/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.MarcasProducto;
import com.cofar.bean.ComponentesProd;
import com.cofar.bean.Producto;
import com.cofar.util.Util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Map;
import javax.faces.context.FacesContext;
import javax.faces.model.SelectItem;

/**
 *
 * @author aquispe
 */


public class ManagedCertificadosSanitarios  extends ManagedBean{

    private Connection con=null;
    private List<ComponentesProd> componentesProdList=new ArrayList<ComponentesProd>();
    private ComponentesProd componentesProdBean=new ComponentesProd();
    private List<SelectItem> formasFarmaceuticasSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> estadosComponentesProdSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> areasEmpresasSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> tiposArchivosSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> ordenarSelectList=new ArrayList<SelectItem>();
    private Date fechaInicioBuscador=new Date();
    private Date fechaFinalBuscador=new Date();
    private String ordenarFecha="";
    private String tiposArchivos="";
    //para control de marcas
    private List<MarcasProducto> marcasProductoList=new ArrayList<MarcasProducto>();
    private Producto productoBean=new Producto();
    private List<SelectItem> estadosProductoList=new ArrayList<SelectItem>();
    private Date fechaInicioVencimientoBuscar=null;
    private Date fechaFinalVencimientoBuscar=null;
    private Date fechaInicioRegistroBuscar=null;
    private Date fechaFinalRegistroBuscar=null;
    private String ordenarFechaMarca="0";
    private String estadoRegistroDoc="0";
    private MarcasProducto marcasProductoAgregar=new MarcasProducto();
    private MarcasProducto marcasProductoEditar=new MarcasProducto();
    private List<SelectItem> estadosMarcasProductoSelectList=new ArrayList<SelectItem>();
    private String mensaje="";
    private MarcasProducto marcasProductoBean=new MarcasProducto();
    /** Creates a new instance of ManagedCertificadosSanitarios */
    public ManagedCertificadosSanitarios() {
    }
    private void cargarEstadosMarcaProductoSelect()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="SELECT e.COD_ESTADO_MARCA_PRODUCTO,e.NOMBRE_ESTADO_MARCA_PRODUCTO"+
                            " FROM ESTADOS_MARCA_PRODUCTO e order by e.NOMBRE_ESTADO_MARCA_PRODUCTO";
            ResultSet res=st.executeQuery(consulta);
            estadosMarcasProductoSelectList.clear();
            while(res.next())
            {
                estadosMarcasProductoSelectList.add(new SelectItem(res.getInt("COD_ESTADO_MARCA_PRODUCTO"),res.getString("NOMBRE_ESTADO_MARCA_PRODUCTO")));
            }
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    public String guardarEdicionMarcaProducto_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            String consulta="UPDATE MARCAS_PRODUCTO SET RESOLUCION_RENOVACION = '"+marcasProductoEditar.getResolucionRenovacion()+"',"+
                            " FECHA_REGISTRO_MARCA ='"+sdf.format(marcasProductoEditar.getFechaRegistroMarca())+" 12:00:00',"+
                            " PRODUCTO_RENOVACION = '"+(marcasProductoEditar.isProductoRenovacion()?"1":"0")+"',"+
                            " OBSERVACION = '"+marcasProductoEditar.getObservacion()+"'," +
                            " NOMBRE_MARCA_PRODUCTO = '"+marcasProductoEditar.getNombreMarcaProducto()+"'" +
                            ",COD_ESTADO_MARCA_PRODUCTO='"+marcasProductoEditar.getEstadosMarcaProducto().getCodEstadoMarcaProducto()+"'"+
                            " WHERE COD_MARCA_PRODUCTO = '"+marcasProductoEditar.getCodMarcaProducto()+"'";
            System.out.println("consulta update marca "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se guardo la edicion");
            con.commit();
            pst.close();
            mensaje="1";
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
            mensaje="Ocurrio un erro al momento de guardar la edicion, intente de nuevo";
            con.rollback();
        }
        return null;
    }
    public String guardarNuevaMarcaProducto_action()throws SQLException
    {
        mensaje="";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select isnull(max(m.COD_MARCA_PRODUCTO),0)+1 as codMarcaProducto from MARCAS_PRODUCTO m";
            ResultSet res=st.executeQuery(consulta);
            int codMarca=0;
            if(res.next())codMarca=res.getInt("codMarcaProducto");
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            consulta="INSERT INTO MARCAS_PRODUCTO(COD_MARCA_PRODUCTO, RESOLUCION_RENOVACION,"+
                    " FECHA_REGISTRO_MARCA, URL_RESOLUCION_RENOVACION, PRODUCTO_RENOVACION,"+
                    " OBSERVACION, NOMBRE_MARCA_PRODUCTO,COD_ESTADO_MARCA_PRODUCTO)"+
                    " VALUES ('"+codMarca+"','"+marcasProductoAgregar.getResolucionRenovacion()+"'," +
                    " '"+sdf.format(marcasProductoAgregar.getFechaRegistroMarca())+"',"+
                    " '', '"+(marcasProductoAgregar.isProductoRenovacion()?"1":"0")+"'," +
                    "'"+marcasProductoAgregar.getObservacion()+"','"+marcasProductoAgregar.getNombreMarcaProducto()+"'," +
                    "'"+marcasProductoAgregar.getEstadosMarcaProducto().getCodEstadoMarcaProducto()+"')";
            System.out.println("consulta insert marcar "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro la marca");
            con.commit();st.close();
            pst.close();
            mensaje="1";
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de registrar la marca ";
            con.rollback();
            con.close();
            ex.printStackTrace();
        }
        return null;
    }
    public String eliminarURLMarcaProducto()throws SQLException
    {
        mensaje="1";
        try
        {
            con=Util.openConnection(con);
            con.setAutoCommit(false);
            Map<String,String> params=FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap();
            String consulta=" update MARCAS_PRODUCTO set URL_RESOLUCION_RENOVACION ='' where COD_MARCA_PRODUCTO='"+params.get("codMarca")+"'";
            System.out.println("consutla update marca producto "+consulta);
            PreparedStatement pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se quito el pdf");
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch(SQLException ex)
        {
            mensaje="Ocurrio un error al momento de quitar el pdf, intente de nuevo";
            ex.printStackTrace();
            con.rollback();
            con.close();
        }
        if(mensaje.equals("1"))
        {
            this.cargarMarcasProducto();
        }
        return null;
    }

    public String agregarMarcasProducto()
    {
        marcasProductoAgregar=new MarcasProducto();
        return null;
    }
    public String editarMarcasProducto()
    {
        for(MarcasProducto bean:marcasProductoList)
        {
            if(bean.getChecked())
            {
                marcasProductoEditar=bean;
            }
        }
        return null;
    }
    public String eliminarMarcasProducto_action()throws SQLException
    {
        mensaje="";
        for(MarcasProducto bean:marcasProductoList)
        {
            if(bean.getChecked())
            {
                try
                {
                    con=Util.openConnection(con);
                    con.setAutoCommit(false);
                    String consulta="delete MARCAS_PRODUCTO  where COD_MARCA_PRODUCTO='"+bean.getCodMarcaProducto()+"'";
                    System.out.println("consulta delete marca "+consulta);
                    PreparedStatement pst =con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se elimino la marca");
                    con.commit();
                    pst.close();
                    mensaje="1";
                    con.close();
                }
                catch(SQLException ex)
                {
                    ex.printStackTrace();
                    mensaje="Ocurrio un error al momento de eliminar la marca, intente de nuevo";
                    con.rollback();
                }
            }
        }
        if(mensaje.equals("1"))
        {
            this.cargarMarcasProducto();
        }
        return null;
    }

    public String getCargarCertificadosComponentesProd()
    {
        fechaInicioBuscador=null;
        fechaFinalBuscador=null;
        ordenarFecha="0";
        tiposArchivos="0";
        componentesProdBean.getAreasEmpresa().setCodAreaEmpresa("0");
        componentesProdBean.getForma().setCodForma("0");
        componentesProdBean.getEstadoCompProd().setCodEstadoCompProd(1);
        this.cargarDatosFiltro();
        this.cargarComponentesProd();
        return null;
    }
    public Date fechaSiguiente(int cantidadMeses)
    {
        Calendar cal = new GregorianCalendar();
        Date fechaActual=new Date();
        cal.setTimeInMillis(fechaActual.getTime());
        cal.add(Calendar.MONTH, cantidadMeses);
        return new Date(cal.getTimeInMillis());
    }
    public Date adicionarAnos(int cantidadAnos,Date fecha)
    {
        Calendar cal = new GregorianCalendar();
        cal.setTimeInMillis(fecha.getTime());
        cal.add(Calendar.YEAR, cantidadAnos);
        return new Date(cal.getTimeInMillis());
    }
    
    public String buscarComponentesProd_action()
    {
        this.cargarComponentesProd();
        return null;
    }
    private void cargarDatosFiltro()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select f.cod_forma,f.nombre_forma from FORMAS_FARMACEUTICAS f  where f.cod_estado_registro=1"+
                            " order by f.nombre_forma";
            ResultSet res=st.executeQuery(consulta);
            formasFarmaceuticasSelectList.clear();
            formasFarmaceuticasSelectList.add(new SelectItem("0","--TODOS--"));
            while(res.next())
            {
                formasFarmaceuticasSelectList.add(new SelectItem(res.getString("cod_forma"),res.getString("nombre_forma")));
            }
            consulta="select ec.COD_ESTADO_COMPPROD,ec.NOMBRE_ESTADO_COMPPROD from ESTADOS_COMPPROD ec order by ec.NOMBRE_ESTADO_COMPPROD";
            res=st.executeQuery(consulta);
            estadosComponentesProdSelectList.clear();
            estadosComponentesProdSelectList.add(new SelectItem("0","---TODOS-"));
            while(res.next())
            {
                estadosComponentesProdSelectList.add(new SelectItem(res.getString("COD_ESTADO_COMPPROD"),res.getString("NOMBRE_ESTADO_COMPPROD")));
            }
            consulta="select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA from AREAS_EMPRESA ae inner join AREAS_FABRICACION af on ae.COD_AREA_EMPRESA=af.COD_AREA_FABRICACION"+
                      " order by ae.NOMBRE_AREA_EMPRESA";
            areasEmpresasSelectList.clear();
            areasEmpresasSelectList.add(new SelectItem("0","--TODOS--"));
            res=st.executeQuery(consulta);
            while(res.next())
            {
                areasEmpresasSelectList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
            }
            tiposArchivosSelectList.clear();
            tiposArchivosSelectList.add(new SelectItem("0","--TODOS--"));
            tiposArchivosSelectList.add(new SelectItem("1","Registrados"));
            tiposArchivosSelectList.add(new SelectItem("2","Proximos a Vencer"));
            tiposArchivosSelectList.add(new SelectItem("3","Vencidos"));
            ordenarSelectList.clear();
            ordenarSelectList.add(new SelectItem("0","--NO--"));
            ordenarSelectList.add(new SelectItem("1","Ascendente"));
            ordenarSelectList.add(new SelectItem("2","Descendente"));
            res.close();
            st.close();
            con.close();
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
     
    }
    private void cargarComponentesProd()
    {
        try
        {
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select isnull(cp.DIRECCION_ARCHIVO_REGISTRO_SANITARIO,'') as DIRECCION_ARCHIVO_REGISTRO_SANITARIO,"+
                            " cp.cod_compprod,cp.nombre_prod_semiterminado,f.nombre_forma,ae.NOMBRE_AREA_EMPRESA"+
                            " ,cp.NOMBRE_GENERICO ,cp.FECHA_VENCIMIENTO_RS,cp.REG_SANITARIO,ep.nombre_estado_prod," +
                            "  (case when (cp.DIRECCION_ARCHIVO_REGISTRO_SANITARIO is not null and"+
                            " cp.DIRECCION_ARCHIVO_REGISTRO_SANITARIO <> '') then ("+
                            " case when cp.FECHA_VENCIMIENTO_RS < '"+sdf.format(new Date())+" 23:59:59' then 'vencido'"+
                            " when cp.FECHA_VENCIMIENTO_RS < '"+sdf.format(fechaSiguiente(1))+" 23:59:59' then"+
                            " 'proximoVencimiento' else 'registrado' end )"+
                            " else '' end) as colorFila"+
                            " from COMPONENTES_PROD cp inner join FORMAS_FARMACEUTICAS f on cp.COD_FORMA=f.cod_forma"+
                            " inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA"+
                            " inner join estados_producto ep on ep.cod_estado_prod=cp.COD_ESTADO_COMPPROD where 1=1"+
                            (componentesProdBean.getEstadoCompProd().getCodEstadoCompProd() == 0 ?"":" and cp.COD_ESTADO_COMPPROD="+componentesProdBean.getEstadoCompProd().getCodEstadoCompProd())+
                            (componentesProdBean.getNombreProdSemiterminado().equals("")?"":" and cp.nombre_prod_semiterminado like '%"+componentesProdBean.getNombreProdSemiterminado()+"%'")+
                            (componentesProdBean.getNombreGenerico().equals("")?"":" and cp.NOMBRE_GENERICO like '%"+componentesProdBean.getNombreGenerico()+"%'" )+
                            (componentesProdBean.getAreasEmpresa().getCodAreaEmpresa().equals("0")?"":" and cp.COD_AREA_EMPRESA='"+componentesProdBean.getAreasEmpresa().getCodAreaEmpresa()+"'")+
                            (componentesProdBean.getForma().getCodForma().equals("0")?"":" and cp.COD_FORMA='"+componentesProdBean.getForma().getCodForma()+"'")+
                            (componentesProdBean.getRegSanitario().equals("")?"":" and cp.REG_SANITARIO like '%"+componentesProdBean.getRegSanitario()+"%'")+
                            ((fechaInicioBuscador!=null && fechaFinalBuscador!=null)?" and cp.FECHA_VENCIMIENTO_RS between '"+sdf.format(fechaInicioBuscador)+" 00:00:00' and '"+sdf.format(fechaFinalBuscador)+" 23:59:59'":"")+
                            (tiposArchivos.equals("1")?" and cp.DIRECCION_ARCHIVO_REGISTRO_SANITARIO is not null and cp.DIRECCION_ARCHIVO_REGISTRO_SANITARIO <> ''":"")+
                            (tiposArchivos.equals("2")?" and cp.DIRECCION_ARCHIVO_REGISTRO_SANITARIO is not null and cp.DIRECCION_ARCHIVO_REGISTRO_SANITARIO <> '' and cp.FECHA_VENCIMIENTO_RS between '"+sdf.format(new Date())+" 00:00:00' and '"+sdf.format(fechaSiguiente(1))+" 23:59:59'":"")+
                            (tiposArchivos.equals("3")?" and cp.DIRECCION_ARCHIVO_REGISTRO_SANITARIO is not null and cp.DIRECCION_ARCHIVO_REGISTRO_SANITARIO <> '' and cp.FECHA_VENCIMIENTO_RS < '"+sdf.format(new Date())+" 23:59:59' ":"")+
                            (ordenarFecha.equals("0")?" order by cp.nombre_prod_semiterminado,f.nombre_forma,ae.NOMBRE_AREA_EMPRESA":
                            (ordenarFecha.equals("1")?" order by cp.FECHA_VENCIMIENTO_RS asc":" order by cp.FECHA_VENCIMIENTO_RS desc"));
            System.out.println("consulta cargar "+consulta);
            
            ResultSet res=st.executeQuery(consulta);
            componentesProdList.clear();
            while(res.next())
            {
                ComponentesProd nuevo=new ComponentesProd();
                nuevo.setColorFila(res.getString("colorFila"));
                nuevo.setCodCompprod(res.getString("cod_compprod"));
                nuevo.setNombreProdSemiterminado(res.getString("nombre_prod_semiterminado"));
                nuevo.setNombreGenerico(res.getString("NOMBRE_GENERICO"));
                nuevo.setRegSanitario(res.getString("REG_SANITARIO"));
                nuevo.setFechaVencimientoRS(res.getDate("FECHA_VENCIMIENTO_RS"));
                nuevo.setDireccionArchivoSanitario(res.getString("DIRECCION_ARCHIVO_REGISTRO_SANITARIO"));
                nuevo.getForma().setNombreForma(res.getString("nombre_forma"));
                nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                nuevo.getEstadoCompProd().setNombreEstadoCompProd(res.getString("nombre_estado_prod"));
                componentesProdList.add(nuevo);
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
    public String getCargarProductosControlMarcas()
    {
        productoBean.getEstadoProducto().setCodEstadoProducto("0");
        this.cargarEstadosMarcaProductoSelect();
        this.cargarEstadosProducto();
        this.cargarMarcasProducto();
        return null;
    }
    private void cargarEstadosProducto()
    {
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta="select ep.cod_estado_prod,ep.nombre_estado_prod from estados_producto ep"+
                            " where ep.cod_estado_registro=1 order by ep.nombre_estado_prod";
            System.out.println("consulta cargar Estados  prod "+consulta);
            ResultSet res=st.executeQuery(consulta);
            estadosProductoList.clear();
            estadosProductoList.add(new SelectItem("0","-TODOS-"));
            while(res.next())
            {
                estadosProductoList.add(new SelectItem(res.getString("cod_estado_prod"),res.getString("nombre_estado_prod")));
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
    
    public String buscarProductoControlMarcas_action()
    {
        this.cargarMarcasProducto();
        return null;
    }
    private void cargarMarcasProducto()
    {
        
        try
        {
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            String consulta="SELECT mp.COD_MARCA_PRODUCTO,mp.NOMBRE_MARCA_PRODUCTO,"+
                            " ISNULL(mp.RESOLUCION_RENOVACION, '') as RESOLUCION_RENOVACION,"+
                            " ISNULL(mp.URL_RESOLUCION_RENOVACION, '') as URL_RESOLUCION_RENOVACION,"+
                            " mp.FECHA_REGISTRO_MARCA,mp.PRODUCTO_RENOVACION,mp.OBSERVACION,"+
                            "(case when mp.FECHA_REGISTRO_MARCA < '"+sdf.format(adicionarAnos(-10,new Date()))+" 23:59:59' then 'vencido'"+
                             " when mp.FECHA_REGISTRO_MARCA< '"+sdf.format(adicionarAnos(-10, fechaSiguiente(3)))+" 23:59:59'then 'proximoVencimiento'"+
                             " else 'registrado' end) as colorFila" +
                             " ,emp.COD_ESTADO_MARCA_PRODUCTO,emp.NOMBRE_ESTADO_MARCA_PRODUCTO"+
                             " FROM MARCAS_PRODUCTO mp INNER JOIN ESTADOS_MARCA_PRODUCTO emp on emp.COD_ESTADO_MARCA_PRODUCTO=mp.COD_ESTADO_MARCA_PRODUCTO" +
                             " where 1=1"+
                            (marcasProductoBean.getNombreMarcaProducto().equals("")?"":" and mp.NOMBRE_MARCA_PRODUCTO like '%"+marcasProductoBean.getNombreMarcaProducto()+"%'")+
                            (marcasProductoBean.getUrlRenovacionResolucion().equals("")?"":" and mp.RESOLUCION_RENOVACION like '%"+marcasProductoBean.getUrlRenovacionResolucion()+"%'")+
                            (fechaInicioRegistroBuscar!=null &&fechaFinalRegistroBuscar!=null?" and mp.FECHA_REGISTRO_MARCA between '"+sdf.format(fechaInicioRegistroBuscar)+" 00:00:00' and '"+sdf.format(fechaFinalRegistroBuscar)+" 23:59:59'":"")+
                            (fechaInicioVencimientoBuscar!=null&&fechaFinalVencimientoBuscar!=null?" and mp.FECHA_REGISTRO_MARCA between '"+sdf.format(adicionarAnos(-10,fechaInicioVencimientoBuscar))+" 00:00:00' " +
                            "and '"+sdf.format(adicionarAnos(-10,fechaFinalVencimientoBuscar))+" 23:59:59'":"")+
                            (marcasProductoBean.getEstadosMarcaProducto().getCodEstadoMarcaProducto()>0?" and mp.COD_ESTADO_MARCA_PRODUCTO='"+
                            marcasProductoBean.getEstadosMarcaProducto().getCodEstadoMarcaProducto()+"'":"")+
                            (marcasProductoBean.getEstadosMarcaProducto().getCodEstadoMarcaProducto()==-1?"  and mp.FECHA_REGISTRO_MARCA between '"+sdf.format(adicionarAnos(-10,new Date()))+" 00:00:00' and '"+sdf.format(adicionarAnos(-10, fechaSiguiente(3)))+" 23:59:59'":"")+
                            (marcasProductoBean.getEstadosMarcaProducto().getCodEstadoMarcaProducto()==-2?"  and mp.FECHA_REGISTRO_MARCA < '"+sdf.format(adicionarAnos(-10,new Date()))+" 00:00:00' ":"")+
                            (ordenarFechaMarca.equals("0")?" order by mp.NOMBRE_MARCA_PRODUCTO":"")+
                            (ordenarFechaMarca.equals("1")?" order by mp.FECHA_REGISTRO_MARCA asc":"")+
                            (ordenarFechaMarca.equals("2")?" order by mp.FECHA_REGISTRO_MARCA desc":"");
            System.out.println("consulta cargar control marcas "+consulta);
            ResultSet res=st.executeQuery(consulta);
            marcasProductoList.clear();
            while(res.next())
            {
                MarcasProducto nuevo=new MarcasProducto();
                nuevo.getEstadosMarcaProducto().setCodEstadoMarcaProducto(res.getInt("COD_ESTADO_MARCA_PRODUCTO"));
                nuevo.getEstadosMarcaProducto().setNombreEstadoMarcaProducto(res.getString("NOMBRE_ESTADO_MARCA_PRODUCTO"));
                nuevo.setCodMarcaProducto(res.getInt("COD_MARCA_PRODUCTO"));
                nuevo.setNombreMarcaProducto(res.getString("NOMBRE_MARCA_PRODUCTO"));
                nuevo.setResolucionRenovacion(res.getString("RESOLUCION_RENOVACION"));
                nuevo.setFechaRegistroMarca(res.getTimestamp("FECHA_REGISTRO_MARCA"));
                nuevo.setFechaExpiracionMarca(nuevo.getFechaRegistroMarca()==null?null:adicionarAnos(10,nuevo.getFechaRegistroMarca()));
                nuevo.setUrlRenovacionResolucion(res.getString("URL_RESOLUCION_RENOVACION"));
                nuevo.setProductoRenovacion(res.getInt("PRODUCTO_RENOVACION")>0);
                nuevo.setObservacion(res.getString("OBSERVACION"));
                nuevo.setColorFila(res.getString("colorFila"));
               marcasProductoList.add(nuevo);
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

    public List<SelectItem> getAreasEmpresasSelectList() {
        return areasEmpresasSelectList;
    }

    public void setAreasEmpresasSelectList(List<SelectItem> areasEmpresasSelectList) {
        this.areasEmpresasSelectList = areasEmpresasSelectList;
    }

    public ComponentesProd getComponentesProdBean() {
        return componentesProdBean;
    }

    public void setComponentesProdBean(ComponentesProd componentesProdBean) {
        this.componentesProdBean = componentesProdBean;
    }

    public List<ComponentesProd> getComponentesProdList() {
        return componentesProdList;
    }

    public void setComponentesProdList(List<ComponentesProd> componentesProdList) {
        this.componentesProdList = componentesProdList;
    }

    public List<SelectItem> getEstadosComponentesProdSelectList() {
        return estadosComponentesProdSelectList;
    }

    public void setEstadosComponentesProdSelectList(List<SelectItem> estadosComponentesProdSelectList) {
        this.estadosComponentesProdSelectList = estadosComponentesProdSelectList;
    }

    public List<SelectItem> getFormasFarmaceuticasSelectList() {
        return formasFarmaceuticasSelectList;
    }

    public void setFormasFarmaceuticasSelectList(List<SelectItem> formasFarmaceuticasSelectList) {
        this.formasFarmaceuticasSelectList = formasFarmaceuticasSelectList;
    }

    public Date getFechaFinalBuscador() {
        return fechaFinalBuscador;
    }

    public void setFechaFinalBuscador(Date fechaFinalBuscador) {
        this.fechaFinalBuscador = fechaFinalBuscador;
    }

  

    public Date getFechaInicioBuscador() {
        return fechaInicioBuscador;
    }

    public void setFechaInicioBuscador(Date fechaInicioBuscador) {
        this.fechaInicioBuscador = fechaInicioBuscador;
    }

    public String getOrdenarFecha() {
        return ordenarFecha;
    }

    public void setOrdenarFecha(String ordenarFecha) {
        this.ordenarFecha = ordenarFecha;
    }

    public List<SelectItem> getOrdenarSelectList() {
        return ordenarSelectList;
    }

    public void setOrdenarSelectList(List<SelectItem> ordenarSelectList) {
        this.ordenarSelectList = ordenarSelectList;
    }

    public String getTiposArchivos() {
        return tiposArchivos;
    }

    public void setTiposArchivos(String tiposArchivos) {
        this.tiposArchivos = tiposArchivos;
    }

    public List<SelectItem> getTiposArchivosSelectList() {
        return tiposArchivosSelectList;
    }

    public void setTiposArchivosSelectList(List<SelectItem> tiposArchivosSelectList) {
        this.tiposArchivosSelectList = tiposArchivosSelectList;
    }

    public Producto getProductoBean() {
        return productoBean;
    }

    public void setProductoBean(Producto productoBean) {
        this.productoBean = productoBean;
    }
    
    public List<SelectItem> getEstadosProductoList() {
        return estadosProductoList;
    }

    public void setEstadosProductoList(List<SelectItem> estadosProductoList) {
        this.estadosProductoList = estadosProductoList;
    }

    public Date getFechaFinalRegistroBuscar() {
        return fechaFinalRegistroBuscar;
    }

    public void setFechaFinalRegistroBuscar(Date fechaFinalRegistroBuscar) {
        this.fechaFinalRegistroBuscar = fechaFinalRegistroBuscar;
    }

    public Date getFechaFinalVencimientoBuscar() {
        return fechaFinalVencimientoBuscar;
    }

    public void setFechaFinalVencimientoBuscar(Date fechaFinalVencimientoBuscar) {
        this.fechaFinalVencimientoBuscar = fechaFinalVencimientoBuscar;
    }

    public Date getFechaInicioRegistroBuscar() {
        return fechaInicioRegistroBuscar;
    }

    public void setFechaInicioRegistroBuscar(Date fechaInicioRegistroBuscar) {
        this.fechaInicioRegistroBuscar = fechaInicioRegistroBuscar;
    }

    public Date getFechaInicioVencimientoBuscar() {
        return fechaInicioVencimientoBuscar;
    }

    public void setFechaInicioVencimientoBuscar(Date fechaInicioVencimientoBuscar) {
        this.fechaInicioVencimientoBuscar = fechaInicioVencimientoBuscar;
    }

    public String getOrdenarFechaMarca() {
        return ordenarFechaMarca;
    }

    public void setOrdenarFechaMarca(String ordenarFechaMarca) {
        this.ordenarFechaMarca = ordenarFechaMarca;
    }

    public String getEstadoRegistroDoc() {
        return estadoRegistroDoc;
    }

    public void setEstadoRegistroDoc(String estadoRegistroDoc) {
        this.estadoRegistroDoc = estadoRegistroDoc;
    }

    public MarcasProducto getMarcasProductoAgregar() {
        return marcasProductoAgregar;
    }

    public void setMarcasProductoAgregar(MarcasProducto marcasProductoAgregar) {
        this.marcasProductoAgregar = marcasProductoAgregar;
    }

    public MarcasProducto getMarcasProductoEditar() {
        return marcasProductoEditar;
    }

    public void setMarcasProductoEditar(MarcasProducto marcasProductoEditar) {
        this.marcasProductoEditar = marcasProductoEditar;
    }

    public List<MarcasProducto> getMarcasProductoList() {
        return marcasProductoList;
    }

    public void setMarcasProductoList(List<MarcasProducto> marcasProductoList) {
        this.marcasProductoList = marcasProductoList;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public List<SelectItem> getEstadosMarcasProductoSelectList() {
        return estadosMarcasProductoSelectList;
    }

    public void setEstadosMarcasProductoSelectList(List<SelectItem> estadosMarcasProductoSelectList) {
        this.estadosMarcasProductoSelectList = estadosMarcasProductoSelectList;
    }

    public MarcasProducto getMarcasProductoBean() {
        return marcasProductoBean;
    }

    public void setMarcasProductoBean(MarcasProducto marcasProductoBean) {
        this.marcasProductoBean = marcasProductoBean;
    }

    
}
