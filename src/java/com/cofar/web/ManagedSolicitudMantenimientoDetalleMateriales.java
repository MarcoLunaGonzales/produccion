/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.SolicitudMantenimiento;
import com.cofar.bean.SolicitudMantenimientoDetalleMateriales;
import com.cofar.bean.SolicitudesCompra;
import com.cofar.bean.SolicitudesCompraDetalle;
import com.cofar.bean.SolicitudesSalida;
import com.cofar.bean.SolicitudesSalidaDetalle;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.model.SelectItem;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author hvaldivia
 */

public class ManagedSolicitudMantenimientoDetalleMateriales {
    Connection con = null;
    SolicitudMantenimiento solicitudMantenimiento = new SolicitudMantenimiento();
    List solicitudMantenimientoDetalleMaterialesList = new ArrayList();
    SolicitudMantenimientoDetalleMateriales solicitudMantenimientoDetalleMateriales = new SolicitudMantenimientoDetalleMateriales();
    SolicitudMantenimientoDetalleMateriales solicitudMantenimientoDetalleMaterialesEditar = new SolicitudMantenimientoDetalleMateriales();
    List materialesList = new ArrayList();
    SolicitudesSalida solicitudesSalida = new SolicitudesSalida();
    SolicitudesSalidaDetalle solicitudesSalidaDetalle = new SolicitudesSalidaDetalle();
    SolicitudesCompra solicitudesCompra = new SolicitudesCompra();
    SolicitudesCompraDetalle solicitudesCompraDetalle = new SolicitudesCompraDetalle();

    List solicitudesSalidaDetalleList = new ArrayList();
    List solicitudesCompraDetalleList = new ArrayList();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    String mensaje = "";
    


    public List getMaterialesList() {
        return materialesList;
    }

    public void setMaterialesList(List materialesList) {
        this.materialesList = materialesList;
    }

    public SolicitudMantenimiento getSolicitudMantenimiento() {
        return solicitudMantenimiento;
    }

    public void setSolicitudMantenimiento(SolicitudMantenimiento solicitudMantenimiento) {
        this.solicitudMantenimiento = solicitudMantenimiento;
    }

    public SolicitudMantenimientoDetalleMateriales getSolicitudMantenimientoDetalleMateriales() {
        return solicitudMantenimientoDetalleMateriales;
    }

    public void setSolicitudMantenimientoDetalleMateriales(SolicitudMantenimientoDetalleMateriales solicitudMantenimientoDetalleMateriales) {
        this.solicitudMantenimientoDetalleMateriales = solicitudMantenimientoDetalleMateriales;
    }

    public SolicitudMantenimientoDetalleMateriales getSolicitudMantenimientoDetalleMaterialesEditar() {
        return solicitudMantenimientoDetalleMaterialesEditar;
    }

    public void setSolicitudMantenimientoDetalleMaterialesEditar(SolicitudMantenimientoDetalleMateriales solicitudMantenimientoDetalleMaterialesEditar) {
        this.solicitudMantenimientoDetalleMaterialesEditar = solicitudMantenimientoDetalleMaterialesEditar;
    }

    public List getSolicitudMantenimientoDetalleMaterialesList() {
        return solicitudMantenimientoDetalleMaterialesList;
    }

    public void setSolicitudMantenimientoDetalleMaterialesList(List solicitudMantenimientoDetalleMaterialesList) {
        this.solicitudMantenimientoDetalleMaterialesList = solicitudMantenimientoDetalleMaterialesList;
    }

    public List getSolicitudesCompraDetalleList() {
        return solicitudesCompraDetalleList;
    }

    public void setSolicitudesCompraDetalleList(List solicitudesCompraDetalleList) {
        this.solicitudesCompraDetalleList = solicitudesCompraDetalleList;
    }

   

    public List getSolicitudesSalidaDetalleList() {
        return solicitudesSalidaDetalleList;
    }

    public void setSolicitudesSalidaDetalleList(List solicitudesSalidaDetalleList) {
        this.solicitudesSalidaDetalleList = solicitudesSalidaDetalleList;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public SolicitudesCompra getSolicitudesCompra() {
        return solicitudesCompra;
    }

    public void setSolicitudesCompra(SolicitudesCompra solicitudesCompra) {
        this.solicitudesCompra = solicitudesCompra;
    }

    public SolicitudesSalida getSolicitudesSalida() {
        return solicitudesSalida;
    }

    public void setSolicitudesSalida(SolicitudesSalida solicitudesSalida) {
        this.solicitudesSalida = solicitudesSalida;
    }

    

    

    





    /** Creates a new instance of ManagedSolicitudMantenimientoDetalleMateriales */
    public ManagedSolicitudMantenimientoDetalleMateriales() {
    }


    public String getCargarContenidoSolicitudMantenimientoDetalleMateriales(){
        try {
             ExternalContext externalContext = FacesContext.getCurrentInstance().getExternalContext();
             Map<String, Object> sessionMap = externalContext.getSessionMap();
             solicitudMantenimiento=(SolicitudMantenimiento)sessionMap.get("solicitudMantenimiento");
             this.cargarSolicitudMantenimientoDetalleMateriales();
             this.cargarDatosSolicitudMantenimiento1();
             this.cargarMateriales();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public void cargarDatosSolicitudMantenimiento(){
        try {
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void cargarDatosSolicitudMantenimiento1(){
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();

            String consulta = " select   s.COD_SOLICITUD_MANTENIMIENTO,  a.COD_AREA_EMPRESA, a.NOMBRE_AREA_EMPRESA, gest.COD_GESTION," +
                    " gest.NOMBRE_GESTION,p.COD_PERSONAL,p.NOMBRE_PILA,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p1.COD_PERSONAL COD_PERSONAL_R," +
                    " p1.NOMBRE_PILA NOMBRE_PILA_R, p1.AP_PATERNO_PERSONAL AP_PATERNO_PERSONAL_R,p1.AP_MATERNO_PERSONAL AP_MATERNO_PERSONAL_R," +
                    " isnull(m.COD_MAQUINA, 0) as COD_MAQUINA, m.NOMBRE_MAQUINA, t.COD_TIPO_SOLICITUD, t.NOMBRE_TIPO_SOLICITUD,e.COD_ESTADO_SOLICITUD," +
                    "isnull(e.NOMBRE_ESTADO_SOLICITUD, '') + '(' + isnull( s.descripcion_estado, '') + ')' nombre_estado_solicitud,tm.COD_NIVEL_SOLICITUD_MANTENIMIENTO," +
                    " tm.NOMBRE_NIVEL_SOLICITUD_MANTENIMIENTO, isnull(ai.COD_AREA_INSTALACION, 0) as COD_AREA_INSTALACION," +
                    " ai.NOMBRE_AREA_INSTALACION, mi.COD_MODULO_INSTALACION,mi.NOMBRE_MODULO_INSTALACION,s.FECHA_SOLICITUD_MANTENIMIENTO," +
                    "s.FECHA_CAMBIO_ESTADOSOLICITUD, pm.COD_PARTE_MAQUINA,pm.NOMBRE_PARTE_MAQUINA,s.OBS_SOLICITUD_MANTENIMIENTO,s.descripcion_estado," +
                    "s.afectara_produccion,isnull(s.NRO_ORDEN_TRABAJO, 0) as NroOrden,s1.cod_solicitud_compra,s2.cod_form_salida,s1.fecha_solicitud_compra,s2.fecha_solicitud from SOLICITUDES_MANTENIMIENTO s" +
                    " inner join AREAS_EMPRESA a on a.COD_AREA_EMPRESA = s.COD_AREA_EMPRESA" +
                    " inner join GESTIONES gest on gest.COD_GESTION = s.COD_GESTION" +
                    " inner join PERSONAL p on p.COD_PERSONAL = s.COD_PERSONAL" +
                    " inner join TIPOS_SOLICITUD_MANTENIMIENTO t on t.COD_TIPO_SOLICITUD = s.COD_TIPO_SOLICITUD_MANTENIMIENTO" +
                    " inner join ESTADOS_SOLICITUD_MANTENIMIENTO e on e.COD_ESTADO_SOLICITUD = s.COD_ESTADO_SOLICITUD_MANTENIMIENTO" +
                    " inner join TIPOS_NIVEL_SOLICITUD_MANTENIMIENTO tm on tm.COD_NIVEL_SOLICITUD_MANTENIMIENTO = s.COD_TIPO_NIVEL_SOLICITUD_MANTENIMIENTO" +
                    " left outer join personal p1 on p1.COD_PERSONAL = s.COD_RESPONSABLE left outer join MAQUINARIAS m on m.COD_MAQUINA = s.COD_MAQUINARIA" +
                    " left outer join PARTES_MAQUINARIA pm on pm.COD_MAQUINA = m.COD_MAQUINA and pm.COD_PARTE_MAQUINA = s.COD_PARTE_MAQUINA" +
                    " left outer join AREAS_INSTALACIONES ai on ai.COD_AREA_INSTALACION = s.COD_AREA_INSTALACION and ai.COD_AREA_EMPRESA = a.COD_AREA_EMPRESA" +
                    " left outer join AREAS_INSTALACIONES_MODULOS aim on aim.COD_AREA_INSTALACION = ai.COD_AREA_INSTALACION and aim.COD_MODULO_INSTALACION = s.COD_MODULO_INSTALACION" +
                    " left outer join MODULOS_INSTALACIONES mi on mi.COD_MODULO_INSTALACION = s.COD_MODULO_INSTALACION" +
                    " left outer join SOLICITUDES_COMPRA s1 on s1.COD_SOLICITUD_COMPRA = s.COD_SOLICITUD_COMPRA" +
                    " left outer join SOLICITUDES_SALIDA s2 on s2.COD_FORM_SALIDA = s.COD_FORM_SALIDA " +
                    " where gest.cod_gestion = s.cod_gestion and s.COD_SOLICITUD_MANTENIMIENTO = '"+solicitudMantenimiento.getCodSolicitudMantenimiento()+"' ";
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            solicitudMantenimiento = new SolicitudMantenimiento();
            if(rs.next()){
                solicitudMantenimiento.setCodSolicitudMantenimiento(rs.getInt("COD_SOLICITUD_MANTENIMIENTO"));
                solicitudMantenimiento.getAreasEmpresa().setCodAreaEmpresa(rs.getString("COD_AREA_EMPRESA"));
                solicitudMantenimiento.getAreasEmpresa().setNombreAreaEmpresa(rs.getString("NOMBRE_AREA_EMPRESA"));
                solicitudMantenimiento.getGestiones().setCodGestion(rs.getString("COD_GESTION"));
                solicitudMantenimiento.getGestiones().setNombreGestion(rs.getString("NOMBRE_GESTION"));
                solicitudMantenimiento.getPersonal_usuario().setCodPersonal(rs.getString("COD_PERSONAL"));
                solicitudMantenimiento.getPersonal_usuario().setNombrePersonal(rs.getString("NOMBRE_PILA"));
                solicitudMantenimiento.getPersonal_usuario().setApPaternoPersonal(rs.getString("AP_PATERNO_PERSONAL"));
                solicitudMantenimiento.getPersonal_usuario().setApMaternoPersonal(rs.getString("AP_MATERNO_PERSONAL"));
                solicitudMantenimiento.getPersonal_ejecutante().setCodPersonal(rs.getString("COD_PERSONAL_R"));
                solicitudMantenimiento.getPersonal_ejecutante().setNombrePersonal(rs.getString("NOMBRE_PILA_R"));
                solicitudMantenimiento.getPersonal_ejecutante().setApPaternoPersonal(rs.getString("AP_PATERNO_PERSONAL_R"));
                solicitudMantenimiento.getPersonal_ejecutante().setApMaternoPersonal(rs.getString("AP_MATERNO_PERSONAL_R"));
                solicitudMantenimiento.getMaquinaria().setCodMaquina(rs.getString("COD_MAQUINA"));
                solicitudMantenimiento.getMaquinaria().setNombreMaquina(rs.getString("NOMBRE_MAQUINA"));
                solicitudMantenimiento.getTiposSolicitudMantenimiento().setCodTipoSolicitud(rs.getInt("COD_TIPO_SOLICITUD"));
                solicitudMantenimiento.getTiposSolicitudMantenimiento().setNombreTipoSolicitud(rs.getString("NOMBRE_TIPO_SOLICITUD"));
                solicitudMantenimiento.getEstadoSolicitudMantenimiento().setCodEstadoSolicitudMantenimiento(rs.getInt("COD_ESTADO_SOLICITUD"));
                solicitudMantenimiento.getEstadoSolicitudMantenimiento().setNombreEstadoSolicitudMantenimiento(rs.getString("NOMBRE_ESTADO_SOLICITUD"));
                solicitudMantenimiento.getTiposNivelSolicitudMantenimiento().setCodTipoNivelSolicitudMantenimiento(rs.getInt("COD_NIVEL_SOLICITUD_MANTENIMIENTO"));
                solicitudMantenimiento.getTiposNivelSolicitudMantenimiento().setNombreNivelSolicitudMantenimiento(rs.getString("NOMBRE_NIVEL_SOLICITUD_MANTENIMIENTO"));
           //     solicitudMantenimiento.getModulosInstalaciones().getAreasInstalacionesModulos().getAreasInstalaciones().setCodAreaInstalacion(rs.getInt("COD_AREA_INSTALACION"));
           //     solicitudMantenimiento.getModulosInstalaciones().getAreasInstalacionesModulos().getAreasInstalaciones().setNombreAreaInstalacion(rs.getString("NOMBRE_AREA_INSTALACION"));
                solicitudMantenimiento.getModulosInstalaciones().setCodModuloInstalacion(rs.getInt("COD_MODULO_INSTALACION"));
                solicitudMantenimiento.getModulosInstalaciones().setNombreModuloInstalacion(rs.getString("NOMBRE_MODULO_INSTALACION"));
                solicitudMantenimiento.setFechaSolicitudMantenimiento(rs.getDate("FECHA_SOLICITUD_MANTENIMIENTO"));
                solicitudMantenimiento.getFechaSolicitudMantenimiento().setTime(rs.getTimestamp("FECHA_SOLICITUD_MANTENIMIENTO").getTime());
                solicitudMantenimiento.setFechaCambioEstadoSolicitud(rs.getDate("FECHA_CAMBIO_ESTADOSOLICITUD"));
                solicitudMantenimiento.getPartesMaquinaria().setCodParteMaquina(rs.getInt("COD_PARTE_MAQUINA"));
                solicitudMantenimiento.getPartesMaquinaria().setNombreParteMaquina(rs.getString("NOMBRE_PARTE_MAQUINA"));
                solicitudMantenimiento.setObsSolicitudMantenimiento(rs.getString("OBS_SOLICITUD_MANTENIMIENTO"));
                solicitudMantenimiento.setDescripcionEstado(rs.getString("DESCRIPCION_ESTADO"));
                solicitudMantenimiento.setAfectaraProduccion(rs.getInt("afectara_produccion"));
                solicitudMantenimiento.setNroOrdenTrabajo(rs.getInt("NroOrden"));
                solicitudMantenimiento.getSolicitudesSalida().setCodFormSalida(rs.getInt("cod_form_salida"));
                solicitudMantenimiento.getSolicitudesCompra().setCodSolicitudCompra(rs.getInt("cod_solicitud_compra"));
                solicitudMantenimiento.getSolicitudesCompra().setFechaSolicitudCompra(rs.getDate("fecha_solicitud_compra"));
                solicitudMantenimiento.getSolicitudesSalida().setFechaSolicitud(rs.getDate("fecha_solicitud"));
                
                //solicitudMantenimiento.getSolicitudesCompra().setCodSolicitudCompra(rs.getInt("cod_solicitud_compra"));
            }

            st.close();
            rs.close();
            con.close();

            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public void cargarSolicitudMantenimientoDetalleMateriales(){
        try {
               

                con = Util.openConnection(con);
                String  consulta = " select s.COD_SOLICITUD_MANTENIMIENTO,s.COD_MATERIAL,m.NOMBRE_MATERIAL,u.NOMBRE_UNIDAD_MEDIDA,s.CANTIDAD,s.DESCRIPCION,s.cod_unidad_medida" +
                        " from SOLICITUDES_MANTENIMIENTO_DETALLE_MATERIALES s " +
                        " inner join materiales m on s.COD_MATERIAL = m.COD_MATERIAL " +
                        " left outer join UNIDADES_MEDIDA u on s.COD_UNIDAD_MEDIDA = u.COD_UNIDAD_MEDIDA " +
                        " where s.COD_SOLICITUD_MANTENIMIENTO = '"+solicitudMantenimiento.getCodSolicitudMantenimiento()+"' ";
                
                System.out.println("consulta" + consulta);
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery(consulta);
                solicitudMantenimientoDetalleMaterialesList.clear();
                while(rs.next()){
                    SolicitudMantenimientoDetalleMateriales solicitudMantenimientoDetalleMaterialesItem = new SolicitudMantenimientoDetalleMateriales();

                    solicitudMantenimientoDetalleMaterialesItem.getSolicitudMantenimiento().setCodSolicitudMantenimiento(rs.getInt("COD_SOLICITUD_MANTENIMIENTO"));
                    solicitudMantenimientoDetalleMaterialesItem.getMateriales().setCodMaterial(rs.getString("COD_MATERIAL"));
                    solicitudMantenimientoDetalleMaterialesItem.getMateriales().setNombreMaterial(rs.getString("NOMBRE_MATERIAL"));
                    solicitudMantenimientoDetalleMaterialesItem.setCantidad(rs.getDouble("CANTIDAD"));
                    solicitudMantenimientoDetalleMaterialesItem.setDescripcion(rs.getString("DESCRIPCION"));
                    solicitudMantenimientoDetalleMaterialesItem.getUnidadesMedida().setNombreUnidadMedida(rs.getString("NOMBRE_UNIDAD_MEDIDA"));
                    solicitudMantenimientoDetalleMaterialesItem.getUnidadesMedida().setCodUnidadMedida(rs.getString("cod_unidad_medida"));
                    solicitudMantenimientoDetalleMaterialesList.add(solicitudMantenimientoDetalleMaterialesItem);
                }
       
        } catch (Exception e) {
            e.printStackTrace();
        }

    }


    public String registrarSolicitudMantenimientoDetalleMateriales_action(){
        try {
            con=Util.openConnection(con);

            String consulta = " INSERT INTO SOLICITUDES_MANTENIMIENTO_DETALLE_MATERIALES (  COD_SOLICITUD_MANTENIMIENTO," +
                    "  COD_MATERIAL,  DESCRIPCION,  CANTIDAD,COD_UNIDAD_MEDIDA) VALUES ('"+solicitudMantenimiento.getCodSolicitudMantenimiento()+"', " +
                    " '"+solicitudMantenimientoDetalleMateriales.getMateriales().getCodMaterial()+"', '"+solicitudMantenimientoDetalleMateriales.getDescripcion()+"',  " +
                    "'"+solicitudMantenimientoDetalleMateriales.getCantidad()+"','"+solicitudMantenimientoDetalleMateriales.getUnidadesMedida().getCodUnidadMedida()+"'); ";
                    
               System.out.println("consulta" + consulta);

               Statement st = con.createStatement();
               st.executeUpdate(consulta);
               this.cargarSolicitudMantenimientoDetalleMateriales();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String agregarSolicitudMantenimientoDetalleMateriales_action(){
        try {
                solicitudMantenimientoDetalleMateriales = new SolicitudMantenimientoDetalleMateriales();
                solicitudMantenimientoDetalleMateriales.setDescripcion(solicitudMantenimiento.getObsSolicitudMantenimiento());
                
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String eliminarSolicitudMantenimientoDetalleMateriales_action(){
        try {
               con=Util.openConnection(con);
               String consulta = "";
               Iterator i = solicitudMantenimientoDetalleMaterialesList.iterator();
               while(i.hasNext()){
                   SolicitudMantenimientoDetalleMateriales solicitudMantenimientoDetalleMaterialesItem = (SolicitudMantenimientoDetalleMateriales)i.next();
                   if(solicitudMantenimientoDetalleMaterialesItem.getChecked().booleanValue()==true){
                   
                       
                         consulta = " DELETE FROM SOLICITUDES_MANTENIMIENTO_DETALLE_MATERIALES " +
                                 " WHERE COD_SOLICITUD_MANTENIMIENTO = '"+solicitudMantenimientoDetalleMaterialesItem.getSolicitudMantenimiento().getCodSolicitudMantenimiento()+"'" +
                                 " AND COD_MATERIAL = '"+solicitudMantenimientoDetalleMaterialesItem.getMateriales().getCodMaterial()+"'";
                                System.out.println("consulta" + consulta) ;
                        Statement st = con.createStatement();
                        st = con.createStatement();
                        st.executeUpdate(consulta);

                       break;
                   }


               }
               this.cargarSolicitudMantenimientoDetalleMateriales();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String editarSolicitudMantenimientoDetalleMateriales_action(){
        try {
               con=Util.openConnection(con);
               Iterator i = solicitudMantenimientoDetalleMaterialesList.iterator();
               while(i.hasNext()){
                   SolicitudMantenimientoDetalleMateriales solicitudMantenimientoDetalleMaterialesItem = (SolicitudMantenimientoDetalleMateriales) i.next();
                   if(solicitudMantenimientoDetalleMaterialesItem.getChecked().booleanValue()==true){
                       solicitudMantenimientoDetalleMateriales =solicitudMantenimientoDetalleMaterialesItem;
                       solicitudMantenimientoDetalleMaterialesEditar.getSolicitudMantenimiento().setCodSolicitudMantenimiento(solicitudMantenimientoDetalleMaterialesItem.getSolicitudMantenimiento().getCodSolicitudMantenimiento());
                       solicitudMantenimientoDetalleMaterialesEditar.getMateriales().setCodMaterial(solicitudMantenimientoDetalleMaterialesItem.getMateriales().getCodMaterial());

                       break;
                   }
               }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String guardarEdicionSolicitudMantenimientoDetalleMateriales_action(){
        try {
            con=Util.openConnection(con);


            String consulta = " UPDATE SOLICITUDES_MANTENIMIENTO_DETALLE_MATERIALES  SET " +                            
                            " COD_MATERIAL = '"+solicitudMantenimientoDetalleMateriales.getMateriales().getCodMaterial()+"'," +
                            " DESCRIPCION = '"+solicitudMantenimientoDetalleMateriales.getDescripcion()+"'," +
                            " CANTIDAD = '"+solicitudMantenimientoDetalleMateriales.getCantidad()+"', " +
                            " COD_UNIDAD_MEDIDA = '"+solicitudMantenimientoDetalleMateriales.getUnidadesMedida().getCodUnidadMedida()+"'" +
                            " WHERE " +
                            " COD_SOLICITUD_MANTENIMIENTO = '"+solicitudMantenimientoDetalleMaterialesEditar.getSolicitudMantenimiento().getCodSolicitudMantenimiento()+"' AND " +
                            " COD_MATERIAL = '"+solicitudMantenimientoDetalleMaterialesEditar.getMateriales().getCodMaterial()+"' ";
                    

             System.out.println("consulta" + consulta);
             Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
             st.executeUpdate(consulta);
             this.cargarSolicitudMantenimientoDetalleMateriales();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    
    public String redireccionar(String direccion) {
        try {
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect(direccion);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void cargarMateriales() {
        try {
            con = (Util.openConnection(con));
            String consulta = " select M.COD_MATERIAL,M.NOMBRE_MATERIAL,u.cod_unidad_medida,u.nombre_unidad_medida " +
                    " from materiales M,unidades_medida u WHERE m.cod_unidad_medida = u.cod_unidad_medida and (M.COD_GRUPO IN(" +
                    " select G.COD_GRUPO from grupos G WHERE G.COD_CAPITULO in(22,18)) or m.cod_material in (2185)) " +
                    " ORDER BY M.NOMBRE_MATERIAL ASC ";
            System.out.println("consulta "+consulta);
            ResultSet rs = null;

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            materialesList.clear();
            rs = st.executeQuery(consulta);
            materialesList.add(new SelectItem("0","-NINGUNO-","0,-NINGUNO-"));
            while (rs.next()) {
                materialesList.add(new SelectItem(rs.getString("COD_MATERIAL"), rs.getString("NOMBRE_MATERIAL"),rs.getString("cod_unidad_medida")+","+rs.getString("nombre_unidad_medida")));
            }

            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    
//    public String solicitudAlmacen_action(){
//        try {
//            ManagedAccesoSistema m = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
//            String codPersonal = m.getUsuarioModuloBean().getCodUsuarioGlobal();
//
//            int codSolicitudOrdenCompra = this.obtieneCodSolicitudOrdenCompra();
//            String consulta = " INSERT INTO SOLICITUDES_COMPRA( COD_SOLICITUD_COMPRA, COD_GESTION,   COD_TIPO_SOLICITUD_COMPRA,   COD_RESPONSABLE_COMPRAS,   COD_ESTADO_SOLICITUD_COMPRA, " +
//                    " ESTADO_SISTEMA,  COD_PERSONAL,   COD_AREA_EMPRESA,   FECHA_SOLICITUD_COMPRA,    OBS_SOLICITUD_COMPRA,   FECHA_ENVIO) " +
//                    " VALUES('" + codSolicitudOrdenCompra + "',  (SELECT G.COD_GESTION FROM GESTIONES G WHERE G.GESTION_ESTADO=1) ," +
//                    " '1', '0' , '1', '1','" + codPersonal + "','86', GETDATE() ,   NULL,   NULL)";
//            System.out.println("consulta "+consulta);
//            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
//            st.executeUpdate(consulta);
//
//
//            //se iteran los materiales que tienen stock y se realiza la solicitud de almacen
//            Iterator i = solicitudMantenimientoDetalleMaterialesList.iterator();
//            while(i.hasNext()){
//                SolicitudMantenimientoDetalleMateriales solicitudMantenimientoDetalleMaterialesItem = (SolicitudMantenimientoDetalleMateriales)i.next();
//                if(solicitudMantenimientoDetalleMaterialesItem.getCantidad()>=solicitudMantenimientoDetalleMaterialesItem.getDisponible()){
//
//                    consulta = " INSERT INTO SOLICITUDES_COMPRA_DETALLE( COD_MATERIAL,   COD_SOLICITUD_COMPRA,   CANT_SOLICITADA,   COD_UNIDAD_MEDIDA, " +
//                            " OBS_MATERIAL_SOLICITUD )  VALUES( '" + solicitudMantenimientoDetalleMaterialesItem.getMateriales().getCodMaterial() + "'," +
//                            " '" + codSolicitudOrdenCompra + "', '" + itemIteracionMaterial.getCantidadSugerida() + "' , '" + itemIteracionMaterial.getCodUnidadMedida() + "',   NULL)";
//                    System.out.println("consulta "+consulta);
//                    st.executeUpdate(consulta);
//                }
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }

    
    public String registrarSolicitudAlmacen_action(){
        try {
            mensaje = "";

             //verificar que no pasen el disponible de almacenes
            Iterator i = solicitudesSalidaDetalleList.iterator();
            while(i.hasNext()){
                SolicitudesSalidaDetalle solicitudesSalidaDetalleItem = (SolicitudesSalidaDetalle)i.next();
                if(solicitudesSalidaDetalleItem.getCantidad()>solicitudesSalidaDetalleItem.getDisponible()){
                    mensaje = " Existen cantidades que sobrepasaron el disponible ";
                    return null;
                }
            }
             if(solicitudesSalidaDetalleList.size()==0){
                    mensaje = " no existen items para realizar la solicitud de almacen ";
                   return null;
             }



            String consulta = "INSERT INTO  SOLICITUDES_SALIDA( COD_GESTION,   COD_FORM_SALIDA,   COD_TIPO_SALIDA_ALMACEN,   COD_ESTADO_SOLICITUD_SALIDA_ALMACEN, " +
                    "  SOLICITANTE,   AREA_DESTINO_SALIDA,   FECHA_SOLICITUD,   COD_LOTE_PRODUCCION,   OBS_SOLICITUD,   ESTADO_SISTEMA,   CONTROL_CALIDAD,   COD_INGRESO_ALMACEN, " +
                    "  COD_ALMACEN,   orden_trabajo) VALUES(   " +
                    "  (SELECT G.COD_GESTION FROM GESTIONES G WHERE G.GESTION_ESTADO=1)," +
                    " '"+solicitudesSalida.getCodFormSalida()+"', " +
                    " '"+solicitudesSalida.getTiposSalidasAlmacen().getCodTipoSalidaAlmacen()+"'," +
                    "'"+solicitudesSalida.getEstadosSolicitudSalidasAlmacen().getCodEstadoSolicitudSalidaAlmacen()+"'," +
                    " '"+solicitudesSalida.getSolicitante().getCodPersonal()+"'," +
                    " '"+solicitudesSalida.getAreaDestinoSalida().getCodAreaEmpresa()+"',  " +
                    " '"+sdf.format(solicitudesSalida.getFechaSolicitud())+"', " +
                    " '"+solicitudesSalida.getCodLoteProduccion()+"'," +
                    " '"+solicitudesSalida.getObsSolicitud()+"'," +
                    " '"+solicitudesSalida.getEstadoSistema()+"', " +
                    " '"+solicitudesSalida.getControlCalidad()+"', " +
                    " '"+solicitudesSalida.getCodIngresoAlmacen()+"'," +
                    " '"+solicitudesSalida.getAlmacenes().getCodAlmacen()+"'," +
                    " '" + solicitudMantenimiento.getNroOrdenTrabajo() + "')   ";
                    
            System.out.println("consulta "+consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate(consulta);

           

            //se iteran los materiales que tienen stock y se realiza la solicitud de almacen
            i = solicitudesSalidaDetalleList.iterator();
            while(i.hasNext()){
                SolicitudesSalidaDetalle solicitudesSalidaDetalleItem = (SolicitudesSalidaDetalle)i.next();
                
                   consulta = " INSERT INTO " +
                        " SOLICITUDES_SALIDA_DETALLE(  COD_FORM_SALIDA,  COD_MATERIAL,   CANTIDAD,   CANTIDAD_ENTREGADA,   COD_UNIDAD_MEDIDA) " +
                        " VALUES('"+solicitudesSalida.getCodFormSalida() +"', " +
                        " '" + solicitudesSalidaDetalleItem.getMateriales().getCodMaterial() + "' , " +
                        " '"+solicitudesSalidaDetalleItem.getCantidad() +"','"+solicitudesSalidaDetalleItem.getCantidadEntregada()+"'," +
                        " '" + solicitudesSalidaDetalleItem.getUnidadesMedida().getCodUnidadMedida() + "') ";
                    System.out.println("consulta "+consulta);
                    st.executeUpdate(consulta);
            }
            //se actualiza la solicitud de mantenimiento con la solicitud de salida de almacenes

             consulta = " UPDATE SOLICITUDES_MANTENIMIENTO  SET " +
                    "  COD_FORM_SALIDA = '"+solicitudesSalida.getCodFormSalida()+"',COD_ESTADO_SOLICITUD_MANTENIMIENTO=5 " +
                    " WHERE  COD_SOLICITUD_MANTENIMIENTO = '"+solicitudMantenimiento.getCodSolicitudMantenimiento()+"' ";
             solicitudMantenimiento.getSolicitudesSalida().setCodFormSalida(solicitudesSalida.getCodFormSalida());
             System.out.println("consulta "+consulta);
             st.executeUpdate(consulta);
             

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int obtieneCodSolicitudOrdenCompra() {
        int codSolicitudCompra = 0;
        try {
            String consulta = " SELECT MAX(isnull(SC.COD_SOLICITUD_COMPRA,0))+1 COD_SOLICITUD_COMPRA FROM SOLICITUDES_COMPRA SC ";
            System.out.println("consulta "+consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            if (rs.next()) {
                codSolicitudCompra = rs.getInt("COD_SOLICITUD_COMPRA");
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return codSolicitudCompra;
    }
    
    public int obtieneCodSolicitudSalidaAlmacen() {
        int codSolicitudSalida = 0;
        try {
            String consulta = " SELECT (MAX(SS.COD_FORM_SALIDA)+1) AS COD_FORM_SALIDA FROM SOLICITUDES_SALIDA SS ";
            System.out.println("consulta "+consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            if (rs.next()) {
                codSolicitudSalida = rs.getInt("COD_FORM_SALIDA");
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return codSolicitudSalida;
    }

    

    public String registrarSolicitudCompra_action(){
        try {
            mensaje = "";
             //verificar que no pasen el disponible de almacenes
            
            if(solicitudesCompraDetalleList.size()==0){
                    mensaje = " no existen items para realizar la solicitud de compra ";
                   return null;
            }

            String consulta = " INSERT INTO dbo.SOLICITUDES_COMPRA( COD_SOLICITUD_COMPRA, COD_GESTION,   COD_TIPO_SOLICITUD_COMPRA,   COD_RESPONSABLE_COMPRAS,   COD_ESTADO_SOLICITUD_COMPRA, " +
                    " ESTADO_SISTEMA,  COD_PERSONAL,   COD_AREA_EMPRESA,   FECHA_SOLICITUD_COMPRA,    OBS_SOLICITUD_COMPRA,   FECHA_ENVIO) " +
                    " VALUES('" + solicitudesCompra.getCodSolicitudCompra() + "',  " +
                    " (SELECT G.COD_GESTION FROM GESTIONES G WHERE G.GESTION_ESTADO=1) ," +
                    " '"+solicitudesCompra.getTiposSolicitudCompra().getCodTipoSolicitudCompra()+"'," +
                    " '"+solicitudesCompra.getResponsableCompras().getCodPersonal()+"' , " +
                    " '"+solicitudesCompra.getEstadosSolicitudCompra().getCodEstadoSolicitudCompra() +"' , " +
                    " '"+solicitudesCompra.getEstadoSistema() +"' , " +
                    " '"+solicitudesCompra.getPersonal().getCodPersonal() +"' , " +
                    " '"+solicitudesCompra.getAreasEmpresa().getCodAreaEmpresa() +"', " +
                    " '"+sdf.format(solicitudesCompra.getFechaSolicitudCompra()) +"'," +
                    " '"+solicitudesCompra.getObsSolicitudCompra() + "'," +
                    " NULL )";
            

            System.out.println("consulta "+consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate(consulta);


            //se iteran los materiales que tienen stock y se realiza la solicitud de almacen
            Iterator i = solicitudesCompraDetalleList.iterator();
            while(i.hasNext()){
                   SolicitudesCompraDetalle solicitudesCompraDetalleItem =  (SolicitudesCompraDetalle) i.next();
                    consulta = " INSERT INTO SOLICITUDES_COMPRA_DETALLE( COD_MATERIAL,   COD_SOLICITUD_COMPRA,   CANT_SOLICITADA,   COD_UNIDAD_MEDIDA, " +
                        " OBS_MATERIAL_SOLICITUD )  VALUES( '" + solicitudesCompraDetalleItem.getMateriales().getCodMaterial() + "'," +
                        " '" + solicitudesCompra.getCodSolicitudCompra() + "'," +
                        " '" + solicitudesCompraDetalleItem.getCantSolicitada() + "' ," +
                        " '" + solicitudesCompraDetalleItem.getUnidadesMedida().getCodUnidadMedida() + "', " +
                        " '" + solicitudesCompraDetalleItem.getObsMaterialSolicitud()+"')";
                    System.out.println("consulta "+consulta);
                    st.executeUpdate(consulta);
            }
            mensaje = " Se genero la solicitud de Compra: " + solicitudesCompra.getCodSolicitudCompra();
            
            //se actualiza la solicitud de mantenimiento con la solicitud de salida de almacenes

             consulta = " UPDATE SOLICITUDES_MANTENIMIENTO  SET " +
                    "  COD_SOLICITUD_COMPRA = '"+solicitudesCompra.getCodSolicitudCompra()+"',COD_ESTADO_SOLICITUD_MANTENIMIENTO=5 " +
                    " WHERE  COD_SOLICITUD_MANTENIMIENTO = '"+solicitudMantenimiento.getCodSolicitudMantenimiento()+"' ";
             solicitudMantenimiento.getSolicitudesSalida().setCodFormSalida(solicitudesSalida.getCodFormSalida());
             System.out.println("consulta "+consulta);
             st.executeUpdate(consulta);
             solicitudMantenimiento.getSolicitudesCompra().setCodSolicitudCompra(solicitudesCompra.getCodSolicitudCompra());

             this.cargarDatosSolicitudMantenimiento1();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String material_change(){
        try {
            solicitudMantenimientoDetalleMateriales.getUnidadesMedida().setCodUnidadMedida("0");
            solicitudMantenimientoDetalleMateriales.getUnidadesMedida().setNombreUnidadMedida("");
            Iterator i = materialesList.iterator();
            while(i.hasNext()){
                SelectItem s = (SelectItem)i.next();
                if(s.getValue().toString().equals(solicitudMantenimientoDetalleMateriales.getMateriales().getCodMaterial())){
                    //System.out.println("la unidad medida seleccionada " + s.getDescription());
                    System.out.println("la informacion seleccionada " +  s.getDescription().split(",")[0] + " "  + s.getDescription().split(",")[1]);
                    solicitudMantenimientoDetalleMateriales.getUnidadesMedida().setCodUnidadMedida(s.getDescription().split(",")[0]);
                    solicitudMantenimientoDetalleMateriales.getUnidadesMedida().setNombreUnidadMedida(s.getDescription().split(",")[1]);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}

