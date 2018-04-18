/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.Personal;
import com.cofar.bean.PersonalAreaProduccion;
import com.cofar.bean.UsuariosModulos;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.faces.model.SelectItem;
import org.apache.logging.log4j.LogManager;

/**
 *
 * @author aquispe
 */

public class ManagedPersonalAreasProduccion extends ManagedBean
{
    private static final int COD_MODULO_ATLAS_REGISTRO_TOUCH = 10;
    private boolean permisoRegitroUsuariosModulosTouch=false;
    private boolean usuarioExistente = false;
    private List<Personal> personalAreaProduccionList=null;
    private List<PersonalAreaProduccion> personalAreaProduccionAgregarList;
    private PersonalAreaProduccion personalAreaProduccionBuscar=new PersonalAreaProduccion();
    private List<SelectItem> areasEmpresaSelectList=new ArrayList<SelectItem>();
    private List<SelectItem> estadosPersonalAreaSelectList;
    private PersonalAreaProduccion personalAreaProduccionBean=new PersonalAreaProduccion();
    private String comentarioCambio="";
    private Connection con=null;
    private String mensaje="";
    private Personal personalEditarAreas;
    private Personal personalRegistrarUsuario;
    /** Creates a new instance of ManagedPersonalAreasProduccion */
    public ManagedPersonalAreasProduccion()
    {
        LOGGER=LogManager.getRootLogger();
        personalAreaProduccionBuscar.getAreasEmpresa().setCodAreaEmpresa("84");
        personalAreaProduccionBuscar.getEstadosPersonalAreaProduccion().setCodEstadoPersonalAreaProduccion(1);
    }
    
    public String seleccionarPersonalRegistrarUsuarioModulo()
    {
        personalRegistrarUsuario.setUsuariosModulos(new UsuariosModulos());
        usuarioExistente= false;
        try
        {
            con=Util.openConnection(con);
            StringBuilder consulta=new StringBuilder("select um.NOMBRE_USUARIO,um.CONTRASENA_USUARIO")
                                                    .append(" ,STUFF((select ','+ mer.NOMBRE_MODULO")
                                                    .append(" from USUARIOS_MODULOS um1")
                                                            .append(" inner join MODULOS_ERP mer on mer.COD_MODULO = um1.COD_MODULO")
                                                    .append(" where um1.COD_PERSONAL = um.COD_PERSONAL")
                                            .append(" FOR XML PATH('') ),1,1,'') as nombreModulo")
                                            .append(" from USUARIOS_MODULOS um ")
                                                    .append(" inner join personal p on p.COD_PERSONAL = um.COD_PERSONAL")
                                            .append(" where um.COD_PERSONAL =").append(personalRegistrarUsuario.getCodPersonal());
            System.out.println("consulta verificar usuario creado: "+consulta.toString());
            Statement st = con.createStatement();
            ResultSet res = st.executeQuery(consulta.toString());
            if(res.next()){
                usuarioExistente = true;
                personalRegistrarUsuario.getUsuariosModulos().setNombreUsuario(res.getString("NOMBRE_USUARIO"));
                personalRegistrarUsuario.getUsuariosModulos().setContraseniaUsuario(res.getString("nombreModulo").trim());
            }
            else{
                consulta = new StringBuilder("select count(*) as cantidadCoincidencias")

                                    .append(" from USUARIOS_MODULOS um ")
                                    .append(" where um.NOMBRE_USUARIO = ?");
                System.out.println("consulta verificar usuario :"+consulta.toString());
                PreparedStatement pst = con.prepareStatement(consulta.toString());
                personalRegistrarUsuario.getUsuariosModulos().setNombreUsuario(personalRegistrarUsuario.getNombrePersonal().substring(0, 1) + personalRegistrarUsuario.getApPaternoPersonal());
                pst.setString(1,personalRegistrarUsuario.getUsuariosModulos().getNombreUsuario());System.out.println("p1:"+personalRegistrarUsuario.getUsuariosModulos().getNombreUsuario());
                res= pst.executeQuery();
                res.next();
                if(res.getInt("cantidadCoincidencias") > 0){
                    System.out.println("tiene coincidencias probando otro usuario:");
                    personalRegistrarUsuario.getUsuariosModulos().setNombreUsuario(personalRegistrarUsuario.getNombrePersonal().substring(0, 1)+"."+personalRegistrarUsuario.getApPaternoPersonal());
                    pst.setString(1,personalRegistrarUsuario.getUsuariosModulos().getNombreUsuario());System.out.println("p1:"+personalRegistrarUsuario.getUsuariosModulos().getNombreUsuario());
                    res= pst.executeQuery();
                    res.next();
                    if(res.getInt("cantidadCoincidencias") > 0){
                        System.out.println("tiene coincidencias probando otro usuario:");
                        personalRegistrarUsuario.getUsuariosModulos().setNombreUsuario(personalRegistrarUsuario.getNombrePersonal()+personalRegistrarUsuario.getApPaternoPersonal());
                        pst.setString(1,personalRegistrarUsuario.getUsuariosModulos().getNombreUsuario());System.out.println("p1:"+personalRegistrarUsuario.getUsuariosModulos().getNombreUsuario());
                        res= pst.executeQuery();
                        res.next();
                        if(res.getInt("cantidadCoincidencias") > 0){
                            personalRegistrarUsuario.getUsuariosModulos().setNombreUsuario("no asignable consulte con sistemas");
                        }
                    }

                }
            }
            personalRegistrarUsuario.getUsuariosModulos().setNombreUsuario(personalRegistrarUsuario.getUsuariosModulos().getNombreUsuario().toLowerCase());
        }
        catch(SQLException ex) 
        {
            ex.printStackTrace();
        }
        catch(Exception ex) 
        {
            ex.printStackTrace();
        }
        finally
        {
            this.cerrarConexion(con);
        }
        return null;
    }
    public String guardarRegistrarPersonalUsuarioModulo()throws SQLException
    {
        this.transaccionExitosa = false;
        try {
            
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta=new StringBuilder("INSERT INTO USUARIOS_MODULOS(COD_PERSONAL, COD_MODULO, NOMBRE_USUARIO,");
                                        consulta.append(" CONTRASENA_USUARIO, FECHA_VENCIMIENTO,COD_ESTADO_REGISTRO,COD_PERFIL)");
                                if(usuarioExistente){
                                    consulta.append("select top 1 um.COD_PERSONAL")
                                                    .append(",").append(COD_MODULO_ATLAS_REGISTRO_TOUCH)
                                                    .append(",um.NOMBRE_USUARIO")
                                                    .append(",um.CONTRASENA_USUARIO")
                                                    .append(",um.FECHA_VENCIMIENTO")
                                                    .append(",1")
                                                    .append(",0")
                                            .append(" from USUARIOS_MODULOS um")
                                            .append(" where um.COD_PERSONAL = ").append(personalRegistrarUsuario.getCodPersonal());
                                }
                                else{
                                    consulta.append("select top 1 p.COD_PERSONAL")
                                                    .append(",").append(COD_MODULO_ATLAS_REGISTRO_TOUCH)
                                                    .append(",?")//nombre usuario
                                                    .append(",LOWER(convert(varchar(max),HashBytes('MD5',?),2))")
                                                    .append(",DATEADD(day,7,getdate())")
                                                    .append(",1")
                                                    .append(",0")
                                            .append(" from personal p")
                                            .append(" where p.COD_PERSONAL =").append(personalRegistrarUsuario.getCodPersonal());
                                }
            LOGGER.debug("consulta registrar usuario touch: "+consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            if(!usuarioExistente){
                pst.setString(1,personalRegistrarUsuario.getUsuariosModulos().getNombreUsuario());
                pst.setString(2,personalRegistrarUsuario.getUsuariosModulos().getContraseniaUsuario().trim());
            }
            if (pst.executeUpdate() > 0) LOGGER.info("se registro el usuario");
            con.commit();
            this.mostrarMensajeTransaccionExitosa("Se registro satisfactoriamente el usuario");
            
        } catch (SQLException ex) {
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar el usuario, intente de nuevo");
            LOGGER.warn(ex.getMessage());
            this.rollbackConexion(con);
        } catch (Exception ex) {
            this.mostrarMensajeTransaccionFallida("Ocurrio un error al momento de registrar el usuario, intente de nuevo");
            this.rollbackConexion(con);
        } finally {
            this.cerrarConexion(con);
        }
        if(this.transaccionExitosa)
        {
            this.cargarPersonalAreaProduccion();
        }
        return null;
    }
    
    private void cargarPermisosEspecialesAtlas()
    {
        try {
            ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select c.COD_TIPO_PERMISO_ESPECIAL_ATLAS");
                                        consulta.append(" from CONFIGURACION_PERMISOS_ESPECIALES_ATLAS c");
                                        consulta.append(" where c.COD_PERSONAL=").append(managed.getUsuarioModuloBean().getCodUsuarioGlobal());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            permisoRegitroUsuariosModulosTouch=false;
            while (res.next()) 
            {
                switch(res.getInt("COD_TIPO_PERMISO_ESPECIAL_ATLAS"))
                {
                    case 15:
                    {
                        permisoRegitroUsuariosModulosTouch=true;
                        break;
                    }
                }
            }
            res.close();
            st.close();
        } catch (SQLException ex) {
            LOGGER.warn("error", ex);
        } catch (Exception ex) {
            LOGGER.warn("error", ex);
        } finally {
            this.cerrarConexion(con);
        }
    }
    public String guardarEditarPersonalAreaProduccion_action()throws SQLException
    {
        mensaje = "";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("UPDATE  PERSONAL_AREA_PRODUCCION");
                                        consulta.append(" SET COD_ESTADO_PERSONAL_AREA_PRODUCCION=?");
                                        consulta.append(" where COD_PERSONAL=").append(personalEditarAreas.getCodPersonal());
                                                consulta.append(" and COD_AREA_EMPRESA=?");
            LOGGER.debug("consulta cambiar estado personal area produccion " + consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            consulta=new StringBuilder("INSERT INTO PERSONAL_AREA_PRODUCCION(COD_PERSONAL, COD_AREA_EMPRESA,FECHA_INICIO, PERSONAL_GENERICO, OPERARIO_GENERICO,COD_ESTADO_PERSONAL_AREA_PRODUCCION)");
                        consulta.append(" VALUES (");
                                consulta.append(personalEditarAreas.getCodPersonal()).append(",");
                                consulta.append("?,");//areas empresa
                                consulta.append("getdate(),");//fecha inicio
                                consulta.append("0,");//personal generico
                                consulta.append("0,");//operario generico
                                consulta.append("1");//estado personal area produccion
                        consulta.append(")");
            PreparedStatement pstInsert=con.prepareStatement(consulta.toString());
            for(PersonalAreaProduccion bean:personalEditarAreas.getPersonalAreaProduccionList())
            {
                if(bean.getChecked()||bean.getEstadosPersonalAreaProduccion().getCodEstadoPersonalAreaProduccion()==1)
                {
                    if(bean.getChecked())
                    {
                        pst.setInt(1, bean.getEstadosPersonalAreaProduccion().getCodEstadoPersonalAreaProduccion());
                        pst.setString(2,bean.getAreasEmpresa().getCodAreaEmpresa());
                        if(pst.executeUpdate()>0)LOGGER.info("se cambio el estado");
                    }
                    else
                    {
                        pstInsert.setString(1,bean.getAreasEmpresa().getCodAreaEmpresa());
                        if(pstInsert.executeUpdate()>0)LOGGER.info("se agrego el area empresa");
                    }
                }
            }
            con.commit();
            mensaje = "1";
        } 
        catch (SQLException ex) {
            mensaje = "Ocurrio un error al momento de guardar el registro";
            LOGGER.warn(ex.getMessage());
            con.rollback();
        } 
        catch (Exception ex) 
        {
            mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos";
            LOGGER.warn(ex.getMessage());
        }
        finally 
        {
            this.cerrarConexion(con);
        }
        if(mensaje.equals("1"))
        {
            this.cargarPersonalAreaProduccion();
        }
        return null;
    }
    public String seleccionarPersonalEditarAreas_action()
    {
        
        try 
        {
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA,isnull(pap.COD_ESTADO_PERSONAL_AREA_PRODUCCION,2) as COD_ESTADO_PERSONAL_AREA_PRODUCCION,isnull(pap.COD_AREA_EMPRESA,0) as registrado");
                                        consulta.append(" from AREAS_ACTIVIDAD_PRODUCCION aap");
                                                consulta.append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=aap.COD_AREA_EMPRESA");
                                                consulta.append(" left outer join PERSONAL_AREA_PRODUCCION pap on pap.COD_AREA_EMPRESA=ae.COD_AREA_EMPRESA");
                                                        consulta.append(" and pap.COD_PERSONAL=").append(personalEditarAreas.getCodPersonal());
                                        consulta.append(" order by ae.NOMBRE_AREA_EMPRESA        ");
            LOGGER.debug("consulta area Habilitado usuario " + consulta.toString());
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet res = st.executeQuery(consulta.toString());
            personalEditarAreas.setPersonalAreaProduccionList(new ArrayList<PersonalAreaProduccion>());
            while (res.next()) 
            {
                PersonalAreaProduccion nuevo =new PersonalAreaProduccion();
                nuevo.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                nuevo.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                nuevo.getEstadosPersonalAreaProduccion().setCodEstadoPersonalAreaProduccion(res.getInt("COD_ESTADO_PERSONAL_AREA_PRODUCCION"));
                nuevo.setChecked(res.getInt("registrado")>0);
                personalEditarAreas.getPersonalAreaProduccionList().add(nuevo);
            }
            res.close();
            st.close();
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
    private void cargarAreasEmpresaSelect()
    {
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA"
                            + " from AREAS_EMPRESA ae "
                            + " inner join AREAS_ACTIVIDAD_PRODUCCION aap on aap.COD_AREA_EMPRESA=ae.COD_AREA_EMPRESA"
                            + " order by ae.NOMBRE_AREA_EMPRESA";
            ResultSet res = st.executeQuery(consulta);
            areasEmpresaSelectList.clear();
            while (res.next())
            {
                areasEmpresaSelectList.add(new SelectItem(res.getString("COD_AREA_EMPRESA"),res.getString("NOMBRE_AREA_EMPRESA")));
            }
            res.close();
            st.close();
            con.close();
        } 
        catch (SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarEstadosPersonalAreaProduccion()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select epap.COD_ESTADO_PERSONAL_AREA_PRODUCCION,epap.NOMBRE_ESTADO_PERSONAL_AREA_PRODUCCION"+
                              " from ESTADOS_PERSONAL_AREA_PRODUCCION epap order by epap.NOMBRE_ESTADO_PERSONAL_AREA_PRODUCCION";
            ResultSet res = st.executeQuery(consulta);
            estadosPersonalAreaSelectList=new ArrayList<SelectItem>();
            while (res.next())
            {
                estadosPersonalAreaSelectList.add(new SelectItem(res.getInt("COD_ESTADO_PERSONAL_AREA_PRODUCCION"),res.getString("NOMBRE_ESTADO_PERSONAL_AREA_PRODUCCION")));
            }
            res.close();
            st.close();
            con.close();
        } 
        catch (SQLException ex)
        {
            ex.printStackTrace();
        }
    }
    private void cargarPersonalAreaNuevoList()
    {
        try
        {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta =new StringBuilder(" select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal)as nombrePersonal,p.COD_AREA_EMPRESA");
                          consulta.append(" from personal p")
                                  .append(" inner join AREAS_ACTIVIDAD_PRODUCCION aap on aap.COD_AREA_EMPRESA=p.COD_AREA_EMPRESA")
                                 .append(" where p.COD_PERSONAL not in  (select pap.COD_PERSONAL from PERSONAL_AREA_PRODUCCION pap)")
                                        .append(" and p.COD_ESTADO_PERSONA=1");
                          consulta.append(" order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL");
            LOGGER.debug(consulta.toString());
            ResultSet res = st.executeQuery(consulta.toString());
            personalAreaProduccionAgregarList=new ArrayList<PersonalAreaProduccion>();
            while (res.next())
            {
                PersonalAreaProduccion nuevo=new PersonalAreaProduccion();
                nuevo.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
                nuevo.getPersonal().setNombrePersonal(res.getString("nombrePersonal"));
                nuevo.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                personalAreaProduccionAgregarList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    public String cargarPersonalNuevo_action()
    {
        this.cargarPersonalAreaNuevoList();
        return null;
    }
    public String getCargarPersonalAreaProduccion()
    {
        this.cargarPermisosEspecialesAtlas();
        this.cargarPersonalAreaNuevoList();
        this.cargarAreasEmpresaSelect();
        this.cargarEstadosPersonalAreaProduccion();
        this.cargarPersonalAreaProduccion();
        return null;
    }
    public String buscarPersonalAreaProduccion_action()
    {
        this.cargarPersonalAreaProduccion();
        return null;
    }
    
    private void cargarPersonalAreaProduccion()
    {
        try {
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            StringBuilder consulta = new StringBuilder(" select pap.COD_PERSONAL, isnull(p.AP_PATERNO_PERSONAL,pt.AP_PATERNO_PERSONAL) as AP_PATERNO_PERSONAL")
                                            .append(",isnull(p.AP_MATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL) as AP_MATERNO_PERSONAL");
                                consulta.append(" ,isnull(p.NOMBRES_PERSONAL,pt.NOMBRES_PERSONAL) as NOMBRES_PERSONAL,isnull(p.nombre2_personal,pt.nombre2_personal) as nombre2_personal");
                                consulta.append(" ,ae.NOMBRE_AREA_EMPRESA,pap.FECHA_INICIO,pap.OPERARIO_GENERICO" );
                                consulta.append(" ,ae.COD_AREA_EMPRESA,pap.COD_ESTADO_PERSONAL_AREA_PRODUCCION,epap.NOMBRE_ESTADO_PERSONAL_AREA_PRODUCCION");
                                consulta.append(" ,isnull(um.NOMBRE_USUARIO,'') as NOMBRE_USUARIO,um.CONTRASENA_USUARIO");
                          consulta.append(" from PERSONAL_AREA_PRODUCCION pap");
                                consulta.append(  " left outer join personal p on p.COD_PERSONAL = pap.COD_PERSONAL");
                                consulta.append(" left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL = pap.COD_PERSONAL");
                                consulta.append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA = pap.COD_AREA_EMPRESA" );
                                consulta.append(" inner join ESTADOS_PERSONAL_AREA_PRODUCCION epap on epap.COD_ESTADO_PERSONAL_AREA_PRODUCCION=pap.COD_ESTADO_PERSONAL_AREA_PRODUCCION");
                                consulta.append(" left outer join USUARIOS_MODULOS um on um.COD_PERSONAL=pap.COD_PERSONAL");
                                        consulta.append(" and um.COD_MODULO=10");
                            consulta.append(" where 1=1");
                            if(!personalAreaProduccionBuscar.getAreasEmpresa().getCodAreaEmpresa().equals("0"))consulta.append(" and pap.COD_AREA_EMPRESA='").append(personalAreaProduccionBuscar.getAreasEmpresa().getCodAreaEmpresa()).append("'");
                            if(personalAreaProduccionBuscar.getPersonal().getApPaternoPersonal().length()>0)
                                consulta.append(" and (p.AP_PATERNO_PERSONAL LIKE '%").append(personalAreaProduccionBuscar.getPersonal().getApPaternoPersonal()).append("%' OR pt.AP_PATERNO_PERSONAL like '%").append(personalAreaProduccionBuscar.getPersonal().getApPaternoPersonal()).append("%')");
                            if(personalAreaProduccionBuscar.getPersonal().getApMaternoPersonal().length()>0)
                                consulta.append(" and (p.AP_MATERNO_PERSONAL like '%").append(personalAreaProduccionBuscar.getPersonal().getApMaternoPersonal()).append("%' or pt.AP_MATERNO_PERSONAL like '%").append(personalAreaProduccionBuscar.getPersonal().getApMaternoPersonal()).append("%')");
                            if(personalAreaProduccionBuscar.getPersonal().getNombrePersonal().length()>0)
                                consulta.append(" and (p.NOMBRES_PERSONAL like '%").append(personalAreaProduccionBuscar.getPersonal().getNombrePersonal()).append("%' or pt.NOMBRES_PERSONAL like '%").append(personalAreaProduccionBuscar.getPersonal().getNombrePersonal()).append("%')");
                            if(personalAreaProduccionBuscar.getEstadosPersonalAreaProduccion().getCodEstadoPersonalAreaProduccion()>0)
                                consulta.append("and pap.COD_ESTADO_PERSONAL_AREA_PRODUCCION=").append(personalAreaProduccionBuscar.getEstadosPersonalAreaProduccion().getCodEstadoPersonalAreaProduccion());
                            consulta.append(" order by 2,1,ae.NOMBRE_AREA_EMPRESA");
            LOGGER.debug("consulta cargar personal area "+consulta);
            ResultSet res = st.executeQuery(consulta.toString());
            personalAreaProduccionList=new ArrayList<Personal>();
            Personal nuevo=new Personal();
            while (res.next()) 
            {
                if(!nuevo.getCodPersonal().equals(res.getString("COD_PERSONAL")))
                {
                    if(nuevo.getCodPersonal().length()>0)
                    {
                        personalAreaProduccionList.add(nuevo);
                    }
                    nuevo=new Personal();
                    nuevo.getUsuariosModulos().setNombreUsuario(res.getString("NOMBRE_USUARIO"));
                    nuevo.getUsuariosModulos().setContraseniaUsuario(res.getString("CONTRASENA_USUARIO"));
                    nuevo.setCodPersonal(res.getString("COD_PERSONAL"));
                    nuevo.setApPaternoPersonal(res.getString("AP_PATERNO_PERSONAL"));
                    nuevo.setApMaternoPersonal(res.getString("AP_MATERNO_PERSONAL"));
                    nuevo.setNombrePersonal(res.getString("NOMBRES_PERSONAL"));
                    nuevo.setNombre2Personal(res.getString("nombre2_personal"));
                    nuevo.setPersonalAreaProduccionList(new ArrayList<PersonalAreaProduccion>());
                }
                PersonalAreaProduccion bean=new PersonalAreaProduccion();
                bean.getAreasEmpresa().setNombreAreaEmpresa(res.getString("NOMBRE_AREA_EMPRESA"));
                bean.getAreasEmpresa().setCodAreaEmpresa(res.getString("COD_AREA_EMPRESA"));
                bean.getEstadosPersonalAreaProduccion().setCodEstadoPersonalAreaProduccion(res.getInt("COD_ESTADO_PERSONAL_AREA_PRODUCCION"));
                bean.getEstadosPersonalAreaProduccion().setNombreEstadoPersonalAreaProduccion(res.getString("NOMBRE_ESTADO_PERSONAL_AREA_PRODUCCION"));
                bean.setFechaInicio(res.getTimestamp("FECHA_INICIO"));
                nuevo.getPersonalAreaProduccionList().add(bean);
                
            }
            if(nuevo.getCodPersonal().length()>0)
            {
                personalAreaProduccionList.add(nuevo);
            }
            res.close();
            st.close();
            con.close();
        }
        catch (SQLException ex) {
            LOGGER.warn("error",ex);
        }
    }
    /*public String cambiarAreaPersonal_action()
    {
        for(PersonalAreaProduccion bean:personalAreaProduccionList)
        {
            if(bean.getChecked())
            {
                personalAreaProduccionBean=bean;
                comentarioCambio="";
                break;
            }
        }
        return null;
    }*/
    public String guardarNuevoPersonalAreaProduccion_action()throws SQLException
    {
        mensaje="";
        try 
        {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
            StringBuilder consula = new StringBuilder("INSERT INTO PERSONAL_AREA_PRODUCCION(COD_PERSONAL, COD_AREA_EMPRESA,");
                          consula.append(" FECHA_INICIO, OPERARIO_GENERICO,COD_ESTADO_PERSONAL_AREA_PRODUCCION)");
                          consula.append(" VALUES (?,?,'").append(sdf.format(new Date())).append("',?,1)");
            PreparedStatement pst = con.prepareStatement(consula.toString());
            LOGGER.debug("consulta insertar personal area produccion " + consula.toString());
            for(PersonalAreaProduccion bean:personalAreaProduccionAgregarList)
            {
                if(bean.getChecked())
                {
                    pst.setString(1,bean.getPersonal().getCodPersonal());
                    pst.setString(2,bean.getAreasEmpresa().getCodAreaEmpresa());
                    pst.setInt(3,(bean.isOperarioGenerico()?1:0));
                    if(pst.executeUpdate()>0)LOGGER.info("se registro el personal "+bean.getPersonal().getCodPersonal());
                }
            }
            con.commit();
            pst.close();
            mensaje="1";
        }
        catch (SQLException ex) 
        {
            mensaje="Ocurrio un error al momento de registrar la transacción,intente de nuevo";
            LOGGER.warn(ex.getMessage());
        }
        catch (Exception ex) 
        {
            mensaje="Ocurrio un error al momento de registrar la transacción,intente de nuevo";
            LOGGER.error("error",ex);
        }
        finally 
        {
            con.rollback();
            con.close();
        }
        if(mensaje.equals("1"))
        {
            this.cargarPersonalAreaProduccion();
        }
        return null;
    }
    public String guardarCambioAreaEstadoPersonal_action()throws SQLException
    {
        mensaje="";
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            String consulta = "insert into PERSONAL_AREA_PRODUCCION_DETALLE"+
                              " select pap.COD_PERSONAL,pap.COD_AREA_EMPRESA,pap.FECHA_INICIO,'"+sdf.format(new Date())+"'" +
                              " ,'"+comentarioCambio+"', pap.COD_ESTADO_PERSONAL_AREA_PRODUCCION"+
                              " from PERSONAL_AREA_PRODUCCION pap where pap.COD_PERSONAL='"+personalAreaProduccionBean.getPersonal().getCodPersonal()+"'";
            System.out.println("consulta registrar historico "+consulta);
            PreparedStatement pst = con.prepareStatement(consulta);
            if (pst.executeUpdate() > 0)System.out.println("se rgistro el historico");
            consulta="UPDATE  PERSONAL_AREA_PRODUCCION SET COD_AREA_EMPRESA='"+personalAreaProduccionBean.getAreasEmpresa().getCodAreaEmpresa()+"'"+
                     " ,FECHA_INICIO='"+sdf.format(new Date())+"',OPERARIO_GENERICO='"+(personalAreaProduccionBean.isOperarioGenerico()?1:0)+"'" +
                     ", COD_ESTADO_PERSONAL_AREA_PRODUCCION='"+personalAreaProduccionBean.getEstadosPersonalAreaProduccion().getCodEstadoPersonalAreaProduccion()+"'"+
                     " where COD_PERSONAL='"+personalAreaProduccionBean.getPersonal().getCodPersonal()+"'";
            System.out.println("consulta actualizar area personal "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro el cambio de area");
            con.commit();
            mensaje="1";
            pst.close();
            con.close();
        }
        catch (SQLException ex) {
            con.rollback();
            con.close();
            mensaje="Ocurrio un error al momento de registrar el cambio de area, intente de nuevo";
            ex.printStackTrace();
        }
        if(mensaje.equals("1"))
        {
            this.cargarPersonalAreaProduccion();
        }
        return null;
    }
 
    public PersonalAreaProduccion getPersonalAreaProduccionBuscar() {
        return personalAreaProduccionBuscar;
    }

    public void setPersonalAreaProduccionBuscar(PersonalAreaProduccion personalAreaProduccionBuscar) {
        this.personalAreaProduccionBuscar = personalAreaProduccionBuscar;
    }

    public List<Personal> getPersonalAreaProduccionList() {
        return personalAreaProduccionList;
    }

    public void setPersonalAreaProduccionList(List<Personal> personalAreaProduccionList) {
        this.personalAreaProduccionList = personalAreaProduccionList;
    }

    

    public List<SelectItem> getAreasEmpresaSelectList() {
        return areasEmpresaSelectList;
    }

    public void setAreasEmpresaSelectList(List<SelectItem> areasEmpresaSelectList) {
        this.areasEmpresaSelectList = areasEmpresaSelectList;
    }

    public PersonalAreaProduccion getPersonalAreaProduccionBean() {
        return personalAreaProduccionBean;
    }

    public void setPersonalAreaProduccionBean(PersonalAreaProduccion personalAreaProduccionBean) {
        this.personalAreaProduccionBean = personalAreaProduccionBean;
    }

    public String getComentarioCambio() {
        return comentarioCambio;
    }

    public void setComentarioCambio(String comentarioCambio) {
        this.comentarioCambio = comentarioCambio;
    }

    public List<SelectItem> getEstadosPersonalAreaSelectList() {
        return estadosPersonalAreaSelectList;
    }

    public void setEstadosPersonalAreaSelectList(List<SelectItem> estadosPersonalAreaSelectList) {
        this.estadosPersonalAreaSelectList = estadosPersonalAreaSelectList;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public List<PersonalAreaProduccion> getPersonalAreaProduccionAgregarList() {
        return personalAreaProduccionAgregarList;
    }

    public void setPersonalAreaProduccionAgregarList(List<PersonalAreaProduccion> personalAreaProduccionAgregarList) {
        this.personalAreaProduccionAgregarList = personalAreaProduccionAgregarList;
    }

    public Personal getPersonalEditarAreas() {
        return personalEditarAreas;
    }

    public void setPersonalEditarAreas(Personal personalEditarAreas) {
        this.personalEditarAreas = personalEditarAreas;
    }

    public boolean isPermisoRegitroUsuariosModulosTouch() {
        return permisoRegitroUsuariosModulosTouch;
    }

    public void setPermisoRegitroUsuariosModulosTouch(boolean permisoRegitroUsuariosModulosTouch) {
        this.permisoRegitroUsuariosModulosTouch = permisoRegitroUsuariosModulosTouch;
    }

    public Personal getPersonalRegistrarUsuario() {
        return personalRegistrarUsuario;
    }

    public void setPersonalRegistrarUsuario(Personal personalRegistrarUsuario) {
        this.personalRegistrarUsuario = personalRegistrarUsuario;
    }

    public boolean isUsuarioExistente() {
        return usuarioExistente;
    }

    public void setUsuarioExistente(boolean usuarioExistente) {
        this.usuarioExistente = usuarioExistente;
    }

}