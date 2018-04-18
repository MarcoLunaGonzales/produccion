/*
 * ManagedCliente.java
 
 * Created on 25 de febrero de 2008, 17:46
 *
 */

package com.cofar.web;


import com.cofar.bean.UsuariosModulos;
import com.cofar.util.Util;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.logging.log4j.LogManager;

/**
 *
 * @author Wilson
 * @company COFAR
 */
public class ManagedAccesoSistema extends ManagedBean{
    
    /** Creates a new instance of ManagedCliente */
    private static final int COD_MODULO_ATLAS = 6;
    private UsuariosModulos usuarioModuloBean=new UsuariosModulos();
    private Connection con;
    private String codigoModulo="6";
    private String mensajeErrorGlobal="";
    private List tiposAlmacenVentaList=new ArrayList();
    private String codigoTipoAlmacenVentaGlobal="";
    private String nombreTipoAlmacenVentaGlobal="";
    private String codAreaEmpresaGlobal="";
    private String nombreAreaEmpresaGolbal="";
    private int cantidadDiasFaltantesVencimiento = 0;
    
    
    public ManagedAccesoSistema() {
        LOGGER=LogManager.getLogger("Loggin");
        clearUsuario();
    }
    public String clearUsuario(){
        UsuariosModulos cc=new UsuariosModulos();
        setUsuarioModuloBean(cc);
        return"";
    }
    public boolean isUsuarioLogin(){
        boolean usuarioLogeado = false;
        try{
            if(Integer.valueOf(usuarioModuloBean.getCodUsuarioGlobal()) > 0)
                usuarioLogeado = true;
            else 
                usuarioLogeado = false;
        }
        catch(Exception ex){
            usuarioLogeado = false;
        }
        return usuarioLogeado;
    }
    public String getObtenerCodigo(){
        
        try {
            con=Util.openConnection(con);
            String sqlA="select p.cod_personal,p.nombres_personal,p.ap_paterno_personal,p.ap_materno_personal,p.cod_area_empresa";
            sqlA+=" from PERSONAL p,AREAS_EMPRESA ae,AGENCIAS_VENTA av";
            sqlA+=" where ae.COD_AREA_EMPRESA = av.COD_AREA_EMPRESA and";
            sqlA+=" av.COD_AREA_EMPRESA = p.cod_area_empresa and";
            sqlA+=" p.COD_PERSONAL ="+usuarioModuloBean.getCodUsuarioGlobal();
            Statement stA=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rsA=stA.executeQuery(sqlA);
            String codAreaEmpresa="";
            while(rsA.next()){
                rsA.getString(1);
                rsA.getString(2);
                rsA.getString(3);
                rsA.getString(4);
                codAreaEmpresa=rsA.getString(5);
            }
            setCodAreaEmpresaGlobal(codAreaEmpresa);
            setCodigoTipoAlmacenVentaGlobal(codAreaEmpresa);
            String  sql="select nombre_area_empresa";
            sql+=" from areas_empresa";
            sql+=" where cod_area_empresa="+codAreaEmpresa;
            System.out.println("sql:"+sql);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs=st.executeQuery(sql);
            while (rs.next()){
                setNombreTipoAlmacenVentaGlobal(rs.getString("nombre_area_empresa"));
            }
            if(rs!=null){
                rs.close();
                st.close();
                rs=null;st=null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }
    public String terminarSessionUsuario()
    {
        HttpSession session=(HttpSession)FacesContext.getCurrentInstance().getExternalContext().getSession(false);
        session.invalidate();
        
        return null;
    }
    private String encriptaEnMD5(String textoEncriptar)
    {
        char[] CONSTS_HEX = { '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f' };
        try
        {
            MessageDigest msgd = MessageDigest.getInstance("MD5");
            byte[] bytes = msgd.digest(textoEncriptar.getBytes());
            StringBuilder textoEncriptado = new StringBuilder(2 * bytes.length);
            for (int i = 0; i < bytes.length; i++){
                int bajo = (int)(bytes[i] & 0x0f);
                int alto = (int)((bytes[i] & 0xf0) >> 4);
                textoEncriptado.append(CONSTS_HEX[alto]);
                textoEncriptado.append(CONSTS_HEX[bajo]);
            }
            return textoEncriptado.toString();
        } catch (NoSuchAlgorithmException e) {
           return null;
        }
    }
    public String actionVerficarUsuario()
    {
        /*if(usuarioModuloBean != null && !usuarioModuloBean.getCodUsuarioGlobal().equals("")){
            setMensajeErrorGlobal("Existe otra session activa en el explorador, debe cerrar la otra session para habilitar una nueva");
            return "accesoSistema";
        }*/
        String sw="0";
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select um.COD_PERSONAL,um.COD_MODULO,p.NOMBRE_PILA,");
                                                consulta.append(" p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.COD_AREA_EMPRESA")
                                                        .append(" ,DATEDIFF(day, getdate(),um.FECHA_VENCIMIENTO) as cantDiasFaltantesVencimiento");
                                    consulta.append(" from usuarios_modulos um");
                                            consulta.append(" inner join personal p on p.COD_PERSONAL=um.COD_PERSONAL");
                                    consulta.append(" where um.COD_MODULO = ").append(COD_MODULO_ATLAS)
                                                .append(" and um.COD_ESTADO_REGISTRO =  1")
                                                .append(" and um.NOMBRE_USUARIO= ?")
                                                .append(" and um.CONTRASENA_USUARIO= ?");
            LOGGER.debug("----------------------------------------------");
            LOGGER.debug("ip: "+((HttpServletRequest)FacesContext.getCurrentInstance().getExternalContext().getRequest()).getRemoteAddr()+"\n"+
                         "host: "+((HttpServletRequest)FacesContext.getCurrentInstance().getExternalContext().getRequest()).getRemoteHost()+"\n"+
                         "puerto :"+((HttpServletRequest)FacesContext.getCurrentInstance().getExternalContext().getRequest()).getRemotePort());
            
            LOGGER.debug("consulta LOGGIN USUARIO" + consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            pst.setString(1, usuarioModuloBean.getNombreUsuario());LOGGER.info("p1: "+usuarioModuloBean.getNombreUsuario());
            //pst.setString(2,usuarioModuloBean.getContraseniaUsuario());LOGGER.info("p2: "+usuarioModuloBean.getContraseniaUsuario());
            pst.setString(2,encriptaEnMD5(usuarioModuloBean.getContraseniaUsuario()));LOGGER.info("p2: "+encriptaEnMD5(usuarioModuloBean.getContraseniaUsuario()));
            ResultSet res=pst.executeQuery();
            if(res.next()) 
            {
                UsuariosModulos bean=new UsuariosModulos();
                bean.setCodUsuarioGlobal(res.getString("cod_personal"));
                bean.setNombrePilaUsuarioGlobal(res.getString("nombre_pila"));
                bean.setApPaternoUsuarioGlobal(res.getString("ap_paterno_personal"));
                bean.setApMaternoUsuarioGlobal(res.getString("ap_materno_personal"));
                codAreaEmpresaGlobal= res.getString("cod_area_empresa");
                bean.setCod_modulo(res.getString("cod_modulo"));
                bean.setSession(encriptaEnMD5(bean.getCodUsuarioGlobal()+"-"+(new Date()).getTime()));
                usuarioModuloBean=bean;
                cantidadDiasFaltantesVencimiento = res.getInt("cantDiasFaltantesVencimiento");
                sw="1";
                consulta=new StringBuilder("update USUARIOS_MODULOS_SESSION ");
                        consulta.append(" set COD_ESTADO_REGISTRO=2");
                        consulta.append(" where COD_PERSONAL=").append(bean.getCodUsuarioGlobal());
                                consulta.append(" and COD_ESTADO_REGISTRO=1");
                LOGGER.debug("consulta terminar session "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se elimino la anterior session");
                consulta=new StringBuilder("INSERT INTO USUARIOS_MODULOS_SESSION(COD_PERSONAL, USU_SESSION,");
                        consulta.append(" USU_FECHA_INICIO, COD_ESTADO_REGISTRO, USU_IP_ACCESO)");
                consulta.append("VALUES (");
                        consulta.append(bean.getCodUsuarioGlobal()).append(",");
                        consulta.append("'").append(bean.getSession()).append("',");
                        consulta.append("getdate(),");
                        consulta.append("1,");
                        consulta.append("'").append(((HttpServletRequest)FacesContext.getCurrentInstance().getExternalContext().getRequest()).getRemoteAddr()).append("'");
                consulta.append(")");
                LOGGER.debug("consulta registrar session "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se registro la session");
                
            }
            else
            {
            }
            res.close();
        } 
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        catch (Exception ex) 
        {
            LOGGER.warn("error", ex);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        if(sw.equals("0")){
            LOGGER.info("Usuario y/o Contraseña Incorrecta");
            setMensajeErrorGlobal("Usuario y/o Contraseña Incorrecta");
            return "accesoSistema";
        }
        else{
            if(cantidadDiasFaltantesVencimiento < 0){
                setMensajeErrorGlobal("Contraseña Vencida");
                return "accesoSistema";
            }
            else{
                LOGGER.info("loggin correcto ");
                return "seleccionTiposAlmacenVenta";
            }
        }
        
        
    }
    public String getVerificarSessionUsuario(){
        
        try {
            String codigoSession = Util.getParameter("session");
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select us.COD_PERSONAL,6 as COD_MODULO,p.NOMBRE_PILA,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.COD_AREA_EMPRESA")
                                                .append(" from USUARIOS_SESION us")
                                                        .append(" inner join PERSONAL p on p.COD_PERSONAL= us.COD_PERSONAL")
                                                .append(" where us.CODIGO_SESION =?");
            LOGGER.debug("consulta obtener usuario session: "+consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            pst.setString(1,codigoSession);LOGGER.info("p1: "+codigoSession);
            ResultSet res=pst.executeQuery();
            if(res.next()) 
            {
                UsuariosModulos bean=new UsuariosModulos();
                bean.setCodUsuarioGlobal(res.getString("cod_personal"));
                bean.setNombrePilaUsuarioGlobal(res.getString("nombre_pila"));
                bean.setApPaternoUsuarioGlobal(res.getString("ap_paterno_personal"));
                bean.setApMaternoUsuarioGlobal(res.getString("ap_materno_personal"));
                codAreaEmpresaGlobal= res.getString("cod_area_empresa");
                bean.setCod_modulo(res.getString("cod_modulo"));
                bean.setSession(encriptaEnMD5(bean.getCodUsuarioGlobal()+"-"+(new Date()).getTime()));
                usuarioModuloBean=bean;
                consulta=new StringBuilder("update USUARIOS_MODULOS_SESSION ");
                        consulta.append(" set COD_ESTADO_REGISTRO=2");
                        consulta.append(" where COD_PERSONAL=").append(bean.getCodUsuarioGlobal());
                                consulta.append(" and COD_ESTADO_REGISTRO=1");
                LOGGER.debug("consulta terminar session "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se elimino la anterior session");
                consulta=new StringBuilder("INSERT INTO USUARIOS_MODULOS_SESSION(COD_PERSONAL, USU_SESSION,");
                        consulta.append(" USU_FECHA_INICIO, COD_ESTADO_REGISTRO, USU_IP_ACCESO)");
                consulta.append("VALUES (");
                        consulta.append(bean.getCodUsuarioGlobal()).append(",");
                        consulta.append("'").append(bean.getSession()).append("',");
                        consulta.append("getdate(),");
                        consulta.append("1,");
                        consulta.append("'").append(((HttpServletRequest)FacesContext.getCurrentInstance().getExternalContext().getRequest()).getRemoteAddr()).append("'");
                consulta.append(")");
                LOGGER.debug("consulta registrar session "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)LOGGER.info("se registro la session");
                FacesContext.getCurrentInstance().getExternalContext().redirect("main1.jsf");
            }
            res.close();
        } 
        catch (SQLException ex) 
        {
            LOGGER.warn("error", ex);
        }
        catch (Exception ex) 
        {
            LOGGER.warn("error", ex);
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        return null;
        
    }
    
    public String getCloseConnection() throws SQLException{
        if(getCon()!=null){
            getCon().close();
        }
        return "";
    }
    public UsuariosModulos getUsuarioModuloBean() {
        return usuarioModuloBean;
    }
    
    public void setUsuarioModuloBean(UsuariosModulos usuarioModuloBean) {
        this.usuarioModuloBean = usuarioModuloBean;
    }
    
    public Connection getCon() {
        return con;
    }
    
    public void setCon(Connection con) {
        this.con = con;
    }
    
    public String getCodigoModulo() {
        return codigoModulo;
    }
    
    public void setCodigoModulo(String codigoModulo) {
        this.codigoModulo = codigoModulo;
    }
    
    public String getMensajeErrorGlobal() {
        return mensajeErrorGlobal;
    }
    
    public void setMensajeErrorGlobal(String mensajeErrorGlobal) {
        this.mensajeErrorGlobal = mensajeErrorGlobal;
    }
    
    public List getTiposAlmacenVentaList() {
        return tiposAlmacenVentaList;
    }
    
    public void setTiposAlmacenVentaList(List tiposAlmacenVentaList) {
        this.tiposAlmacenVentaList = tiposAlmacenVentaList;
    }
    
    public String getCodigoTipoAlmacenVentaGlobal() {
        return codigoTipoAlmacenVentaGlobal;
    }
    
    public void setCodigoTipoAlmacenVentaGlobal(String codigoTipoAlmacenVentaGlobal) {
        this.codigoTipoAlmacenVentaGlobal = codigoTipoAlmacenVentaGlobal;
    }
    
    public String getNombreTipoAlmacenVentaGlobal() {
        return nombreTipoAlmacenVentaGlobal;
    }
    
    public void setNombreTipoAlmacenVentaGlobal(String nombreTipoAlmacenVentaGlobal) {
        this.nombreTipoAlmacenVentaGlobal = nombreTipoAlmacenVentaGlobal;
    }
    
    public String getCodAreaEmpresaGlobal() {
        return codAreaEmpresaGlobal;
    }
    
    public void setCodAreaEmpresaGlobal(String codAreaEmpresaGlobal) {
        this.codAreaEmpresaGlobal = codAreaEmpresaGlobal;
    }
    
    public String getNombreAreaEmpresaGolbal() {
        return nombreAreaEmpresaGolbal;
    }
    
    public void setNombreAreaEmpresaGolbal(String nombreAreaEmpresaGolbal) {
        this.nombreAreaEmpresaGolbal = nombreAreaEmpresaGolbal;
    }

    public int getCantidadDiasFaltantesVencimiento() {
        return cantidadDiasFaltantesVencimiento;
    }

    public void setCantidadDiasFaltantesVencimiento(int cantidadDiasFaltantesVencimiento) {
        this.cantidadDiasFaltantesVencimiento = cantidadDiasFaltantesVencimiento;
    }
    
    
    
}
