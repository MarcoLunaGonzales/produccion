
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script> 
            <script>
                
                function getCodigoReactivo(codigo){
                 //  alert(codigo);
                   location='../formulaMaestraDetalleMPReactivos/navegador_formula_maestraMP.jsf?codigo='+codigo;
                }
                
                function getCodigo(codigo){
                 //  alert(codigo);
                   location='../formulaMaestraDetalleMP/navegador_formula_maestraMP.jsf?codigo='+codigo;
                }
                function getCodigoActividad(codigo){
                //   alert(codigo);
                   location='../actividades_formula_maestra/navegador_actividades_formula.jsf?codigo='+codigo;
                }
                function getCodigoActividadProduccion(codigoFormulaMaestra,codTipoActividadProduccion){
                //   alert(codigo);
                   location='../actividades_formula_maestra/navegador_actividades_formula.jsf?codigo='+codigoFormulaMaestra+'&codTipoActividadProduccion='+codTipoActividadProduccion;
                }
                function getCodigoActividadMicrobiologia(codigoFormulaMaestra,codTipoActividadProduccion){
                //   alert(codigo);
                   location='../actividades_formula_maestra/navegador_actividades_formula.jsf?codigo='+codigoFormulaMaestra+'&codTipoActividadProduccion='+codTipoActividadProduccion;
                }
                function getCodigoActividadControlDeCalidad(codigoFormulaMaestra,codTipoActividadProduccion){
                //   alert(codigo);
                   location='../actividades_formula_maestra/navegador_actividades_formula.jsf?codigo='+codigoFormulaMaestra+'&codTipoActividadProduccion='+codTipoActividadProduccion;
                }
                function getCodigoArea(codigo){
                //   alert(codigo);
                   location='../formulaMaestraEP/navegador_formula_maestraEP.jsf?codigo='+codigo;
                }
                function getCodigoES(codigo){
                 //  alert(codigo);
                   location='../formulaMaestraES/navegador_formula_maestraES.jsf?codigo='+codigo;
                }
                function getCodigoMatProm(codigo){
                //   alert(codigo);
                   location='../formulaMaestraDetalleMPROM/navegador_formula_maestraMPROM.jsf?codigo='+codigo;
                }
                function editarItem(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }
                         
                     }
                      
                   }
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }                                      
                }


                function asignar(nametable){

                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    alert('hola');
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }                         
                     }                      
                   }
                    if(count==0){
                       alert('No selecciono ningun Registro');
                       return false;
                   }else{
                       if(confirm('Desea Asignar como Area Raiz')){
                            if(confirm('Esta seguro de Asignar como Area Raiz')){
                                 return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                   
                   }
                   
                }          
            function eliminar(nametable){
               var count1=0;
               var elements1=document.getElementById(nametable);
               var rowsElement1=elements1.rows;
               //alert(rowsElement1.length);            
               for(var i=1;i<rowsElement1.length;i++){
                    var cellsElement1=rowsElement1[i].cells;
                    var cel1=cellsElement1[0];
                    if(cel1.getElementsByTagName('input').length>0){
                        if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel1.getElementsByTagName('input')[0].checked){
                               count1++;
                           }
                        }
                    }
                    
               }
               //alert(count1);
               if(count1==0){
                    alert('No escogio ningun registro');
                    return false;
               }else{
                
                
                    if(confirm('Desea Eliminar el Registro')){
                        if(confirm('Esta seguro de Eliminar el Registro')){
                            /*var count=0;
                            var elements=document.getElementById(nametable);
                            var rowsElement=elements.rows;
                            
                            for(var i=0;i<rowsElement.length;i++){
                                var cellsElement=rowsElement[i].cells;
                                var cel=cellsElement[0];
                                if(cel.getElementsByTagName('input').length>0){
                                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                        if(cel.getElementsByTagName('input')[0].checked){
                                            count++;
                                        }
                                    }
                                }

                            }*/
                            /*if(count1==0){
                            //alert('No escogio ningun registro');
                            return false;
                            }*/
                            //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                            //cantidadeliminar.value=count;
                            return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                }
           }                
                
                                            </script>
        </head>
        <body >
            <h:form id="form1">               
                <div align="center">
                    <h:outputText value="#{ManagedFormulaMaestraVersion.cargarFormulaMaestraVersion}"   />
                    <h:outputText styleClass="outputTextTitulo"  value="Listado de Version de Formulas Maestras" />
                    <br><br>                    
                    <rich:dataTable value="#{ManagedFormulaMaestraVersion.formulaMaestraList}" var="data" id="dataFormula"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" binding="#{ManagedFormulaMaestraVersion.formulaMaestraDataTable}">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"  title="Producto" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Version"  />
                            </f:facet>
                            <a4j:commandLink onclick="javascript:Richfaces.showModalPanel('panelFormulaMaestraVersiones');"
                            value="#{data.nroVersion}" action="#{ManagedFormulaMaestraVersion.verFormulaMaestraVersion_action}" reRender="contenidoFormulaMaestraVersiones"
                            styleClass="outputTextTitulo">
                            </a4j:commandLink>                            
                        </h:column>                                                
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Lote"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidadLote}" title="Cantidad del Lote" />
                        </h:column>                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Estado de Registro"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoRegistro.nombreEstadoRegistro}" />
                        </h:column>

                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=" M P"  />
                            </f:facet>                            
                            <a4j:commandLink onclick="javascript:Richfaces.showModalPanel('panelFormulaMaestraVersionesMP');" action="#{ManagedFormulaMaestraVersion.verFormulaMaestraDetalleMP_action}"
                            reRender="contenidoFormulaMaestraVersionesMP">
                                <h:graphicImage url="../img/organigrama3.jpg" alt="Materia Prima"   />
                            </a4j:commandLink>
                        </h:column>    
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=" Reactivos"  />
                            </f:facet>                            
                            <a4j:commandLink onclick="javascript:Richfaces.showModalPanel('panelFormulaMaestraVersionesMR');" action="#{ManagedFormulaMaestraVersion.verFormulaMaestraDetalleMReactivo}"
                            reRender="contenidoFormulaMaestraVersionesMR">
                                <h:graphicImage url="../img/organigrama3.jpg" alt="Materia Prima"   />
                            </a4j:commandLink>

                        </h:column>  
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="E P"  />
                            </f:facet>
                            <a4j:commandLink onclick="javascript:Richfaces.showModalPanel('panelFormulaMaestraVersionesEP');" action="#{ManagedFormulaMaestraVersion.verFormulaMaestraEP_action}"
                            reRender="contenidoFormulaMaestraVersionesEP">
                                <h:graphicImage url="../img/organigrama3.jpg" alt="Empaque Primario"   />
                            </a4j:commandLink>                            
                        </h:column>    
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="E S"  />
                            </f:facet>
                            <a4j:commandLink onclick="javascript:Richfaces.showModalPanel('panelFormulaMaestraVersionesES');" action="#{ManagedFormulaMaestraVersion.verFormulaMaestraES_action}"
                            reRender="contenidoFormulaMaestraVersionesES">
                                <h:graphicImage url="../img/organigrama3.jpg" alt="Empaque Primario"   />
                            </a4j:commandLink>                            
                        </h:column> 
                        <%--h:column>
                            <f:facet name="header">
                                <h:outputText value="Procesos de Producción"  />
                            </f:facet>                           
                            <h:outputText value="<a  onclick=\"getCodigoActividadProduccion('#{data.codFormulaMaestra}','1');\" style='cursor:hand;text-decoration:underline' ><img src='../img/organigrama3.jpg' alt='Actividades'></a>  "  escape="false"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Procesos de Microbiologia"  />
                            </f:facet>
                            <h:outputText value="<a  onclick=\"getCodigoActividadMicrobiologia('#{data.codFormulaMaestra}','2');\" style='cursor:hand;text-decoration:underline' ><img src='../img/organigrama3.jpg' alt='Actividades'></a>  "  escape="false"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Procesos de Control de Calidad"  />
                            </f:facet>
                            <h:outputText value="<a  onclick=\"getCodigoActividadControlDeCalidad('#{data.codFormulaMaestra}','3');\" style='cursor:hand;text-decoration:underline' ><img src='../img/organigrama3.jpg' alt='Actividades'></a>  "  escape="false"  />
                        </h:column--%>
                    </rich:dataTable>
                    
                    <br>
                    <%--h:commandButton value="Agregar"   styleClass="btn"  action="#{ManagedFormulaMaestra.actionagregar}"/>
                    <h:commandButton value="Editar" type="submit"   styleClass="btn"  action="#{ManagedFormulaMaestra.actionEditar}" onclick="return editarItem('form1:dataFormula');"/>
                    <h:commandButton value="Eliminar" type="submit"  styleClass="btn"  action="#{ManagedFormulaMaestra.eliminarFormulaMaestra}"  onclick="return eliminar('form1:dataFormula');"/--%>
                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFormulaMaestra.closeConnection}"  />
                
            </h:form>
            <%-- seleccion de version --%>
            <rich:modalPanel id="panelFormulaMaestraVersiones" minHeight="420"
                                     minWidth="800" height="420" width="800" zindex="100"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto">
                        <f:facet name="header">
                            <h:outputText value="Material Primario" />
                        </f:facet>
                        <a4j:form id="form2">
                            <div align="center">
                            <h:panelGroup id="contenidoFormulaMaestraVersiones">
                            <h:outputText value="Versiones de Formula Maestra" />

                                <rich:dataTable  value="#{ManagedFormulaMaestraVersion.formulaMaestraVersionList}"
                                             width="100%"  var="data"
                                             headerClass="headerClassACliente"
                                             onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                             onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                             id="dataFormulaMaestraVersiones"   align="center"
                                             binding="#{ManagedFormulaMaestraVersion.formulaMaestraVersionDataTable}">
                                    <h:column>
                                        <f:facet name="header">
                                            <h:outputText value="nro Version"  />
                                        </f:facet>
                                        <a4j:commandLink value="#{data.nroVersion}" action="#{ManagedFormulaMaestraVersion.seleccionarFormulaMaestraVersion_action}"
                                        reRender="dataFormula" onclick="javascript:Richfaces.hideModalPanel('panelFormulaMaestraVersiones')">

                                        </a4j:commandLink>
                                        
                                    </h:column>
                                    <h:column>
                                        <f:facet name="header">
                                            <h:outputText value="Producto"  />
                                        </f:facet>
                                        <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"  title="Producto" />
                                    </h:column>
                                    <h:column>
                                        <f:facet name="header">
                                            <h:outputText value="Lote"  />
                                        </f:facet>
                                        <h:outputText value="#{data.cantidadLote}" title="Cantidad del Lote" />
                                    </h:column>

                                    <h:column >
                                        <f:facet name="header">
                                            <h:outputText value="Estado de Registro"  />
                                        </f:facet>
                                        <h:outputText value="#{data.estadoRegistro.nombreEstadoRegistro}" />
                                    </h:column>

                            </rich:dataTable>
                            </h:panelGroup>
                            <br/>
                            <%--
                            <a4j:commandButton  value="Terminar Producto" styleClass="btn"
                            onclick="javascript:Richfaces.showModalPanel('panelIngresoAcondicionamiento');javascript:Richfaces.hideModalPanel('panelActividadesProducto')" reRender="contenidoProgramaProduccion,contenidoIngresoAcondicionamiento" action="#{ManagedProgramaProduccion.terminarProductoConActividadesPendientes_action}"
                            ajaxSingle="false" status="statusPeticion" />
                            --%>
                            <input type="button" value="Aceptar" class="btn" onclick="javascript:Richfaces.hideModalPanel('panelFormulaMaestraVersiones')" />
                            </div>
                        </a4j:form>
                    </rich:modalPanel>
                    <%-- materia prima --%>
                     <rich:modalPanel id="panelFormulaMaestraVersionesMP" minHeight="420"
                                     minWidth="800" height="420" width="800" zindex="100"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto">
                        <f:facet name="header">
                            <h:outputText value="Material Primario" />
                        </f:facet>
                        <a4j:form id="form3">
                            <div align="center">
                            <h:panelGroup id="contenidoFormulaMaestraVersionesMP">
                            <h:outputText value="Versiones de Formula Maestra" />

                                <rich:dataTable value="#{ManagedFormulaMaestraVersion.formulaMaestraDetalleMPList}" var="data" id="dataFormulaMaestraDetalleMP"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';"

                                    headerClass="headerClassACliente">
                                        <h:column>
                                            <f:facet name="header">
                                                <h:outputText value=""  />

                                            </f:facet>
                                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                                        </h:column>
                                        <h:column >
                                            <f:facet name="header">
                                                <h:outputText value="Materia Prima"  />
                                            </f:facet>
                                            <h:outputText rendered="#{data.swSi}" style="background-color: #C5F7C8" value="#{data.materiales.nombreMaterial}"  />
                                            <h:outputText rendered="#{data.swNo}" value="#{data.materiales.nombreMaterial}" />
                                        </h:column>
                                        <h:column >
                                            <f:facet name="header">
                                                <h:outputText value="Cantidad"  />
                                            </f:facet>
                                            <h:outputText value="#{data.cantidad}" />
                                        </h:column>
                                        <h:column >
                                            <f:facet name="header">
                                                <h:outputText value="Unidad Medida"  />
                                            </f:facet>
                                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}" />
                                        </h:column>

                                        <h:column >
                                            <f:facet name="header">
                                                <h:outputText value="Fracciones"  />
                                            </f:facet>
                                            <h:outputText value="#{data.nroPreparaciones}" />
                                        </h:column>
                                        <h:column >
                                            <f:facet name="header">
                                                <h:outputText value="Fracciones Detalle"  />
                                            </f:facet>
                                            <h:dataTable value="#{data.fraccionesDetalleList}" columnClasses="tituloCampo"
                                                         var="val" id="zonasDetalle" style="width:100%;border:0px solid red;text-align:right;" width="100%" >
                                                <h:column>
                                                    <h:outputText value="#{val.cantidad}" style="text-align:right;"  ><f:convertNumber maxFractionDigits="2" /></h:outputText>
                                                </h:column>
                                            </h:dataTable>
                                        </h:column>
                                        <h:column >
                                            <f:facet name="header">
                                                <h:outputText value="Fracciones Detalle"  />
                                            </f:facet>
                                            <h:outputText value="<a  onclick=\"getCodigoES('#{data.materiales.codMaterial}');\" style='cursor:hand;text-decoration:underline' >Modificar Fracciones</a>  "  escape="false"  />
                                        </h:column>

                    </rich:dataTable>
                            </h:panelGroup>
                            <br/>
                            <%--
                            <a4j:commandButton  value="Terminar Producto" styleClass="btn"
                            onclick="javascript:Richfaces.showModalPanel('panelIngresoAcondicionamiento');javascript:Richfaces.hideModalPanel('panelActividadesProducto')" reRender="contenidoProgramaProduccion,contenidoIngresoAcondicionamiento" action="#{ManagedProgramaProduccion.terminarProductoConActividadesPendientes_action}"
                            ajaxSingle="false" status="statusPeticion" />
                            --%>
                            <input type="button" value="Aceptar" class="btn" onclick="javascript:Richfaces.hideModalPanel('panelFormulaMaestraVersionesMP')" />
                            </div>
                        </a4j:form>
                    </rich:modalPanel>

                <%-- material reactivo --%>
                     <rich:modalPanel id="panelFormulaMaestraVersionesMR" minHeight="420"
                                     minWidth="800" height="420" width="800" zindex="100"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto">
                        <f:facet name="header">
                            <h:outputText value="Material Primario" />
                        </f:facet>
                        <a4j:form id="form4">
                            <div align="center">
                            <h:panelGroup id="contenidoFormulaMaestraVersionesMR">
                            <h:outputText value="Versiones de Formula Maestra" />
                            
                            Material Reactivo de: <h:outputText value="#{ManagedFormulaMaestraVersion.formulaMaestraSeleccionada.componentesProd.nombreProdSemiterminado}" />
                            <%--h:outputText value="#{areasdependientes.nombreAreaEmpresa}"   /--%>
                        <br><br>
                            
                            <rich:dataTable value="#{ManagedFormulaMaestraVersion.formulaMaestraDetalleMReactivoList}" var="data" id="dataFormulaMaestraMRVersiones"
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                            onRowMouseOver="this.style.backgroundColor='#CCDFFA';"
                                            headerClass="headerClassACliente" >
                                <h:column>
                                    <f:facet name="header">
                                        <h:outputText value="Materia Prima"  />
                                    </f:facet>
                                    <h:outputText  value="#{data.materiales.nombreMaterial}" />
                                </h:column>
                                <h:column>
                                    <f:facet name="header">
                                        <h:outputText value="Cantidad"  />
                                    </f:facet>
                                    <h:outputText value="#{data.cantidad}" />
                                </h:column>
                                <h:column>
                                    <f:facet name="header">
                                        <h:outputText value="Unidad Medida"  />
                                    </f:facet>
                                    <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}" />
                                </h:column>

                                <%--h:column >
                                    <f:facet name="header">
                                        <h:outputText value="Fracciones"  />
                                    </f:facet>
                                    <h:outputText value="#{data.nroPreparaciones}" />
                                </h:column--%>
                            </rich:dataTable>

                                
                            </h:panelGroup>
                            <br/>
                            <%--
                            <a4j:commandButton  value="Terminar Producto" styleClass="btn"
                            onclick="javascript:Richfaces.showModalPanel('panelIngresoAcondicionamiento');javascript:Richfaces.hideModalPanel('panelActividadesProducto')" reRender="contenidoProgramaProduccion,contenidoIngresoAcondicionamiento" action="#{ManagedProgramaProduccion.terminarProductoConActividadesPendientes_action}"
                            ajaxSingle="false" status="statusPeticion" />
                            --%>
                            <input type="button" value="Aceptar" class="btn" onclick="javascript:Richfaces.hideModalPanel('panelFormulaMaestraVersionesMR')" />
                            </div>
                        </a4j:form>
                    </rich:modalPanel>


              <%-- empaque primario --%>
                     <rich:modalPanel id="panelFormulaMaestraVersionesEP" minHeight="420"
                                     minWidth="800" height="420" width="800" zindex="100"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto">
                        <f:facet name="header">
                            <h:outputText value="Empaque Primario" />
                        </f:facet>
                        <a4j:form id="form5">
                            <div align="center">
                            <h:panelGroup id="contenidoFormulaMaestraVersionesEP">

                            Empaque Primario de: <h:outputText value="#{ManagedFormulaMaestraVersion.formulaMaestraSeleccionada.componentesProd.nombreProdSemiterminado}" />
                            <%--h:outputText value="#{areasdependientes.nombreAreaEmpresa}"   /--%>
                            <br><br>                                
                                <rich:dataTable value="#{ManagedFormulaMaestraVersion.formulaMaestraEPList}" var="data" id="dataFormulaMaestraEP"
                                                onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                                onRowMouseOver="this.style.backgroundColor='#CCDFFA';"
                                                headerClass="headerClassACliente" binding="#{ManagedFormulaMaestraVersion.formulaMaestraEPDataTable}" >
                                    <h:column>
                                        <f:facet name="header">
                                            <h:outputText value=""  />

                                        </f:facet>
                                        <h:selectBooleanCheckbox value="#{data.checked}"  />
                                    </h:column>
                                    <h:column >
                                        <f:facet name="header">
                                            <h:outputText value="Envase Primario"  />
                                        </f:facet>
                                        <h:outputText value="#{data.presentacionesPrimarias.envasesPrimarios.nombreEnvasePrim}" />
                                    </h:column>
                                    <h:column >
                                        <f:facet name="header">
                                            <h:outputText value="Cantidad"  />
                                        </f:facet>
                                        <h:outputText value="#{data.presentacionesPrimarias.cantidad}" />
                                    </h:column>
                                    <h:column>
                                        <f:facet name="header">
                                            <h:outputText value=""  />
                                        </f:facet>
                                        <a4j:commandLink onclick="javascript:Richfaces.showModalPanel('panelFormulaMaestraVersionesEPDetalle');" action="#{ManagedFormulaMaestraVersion.verFormulaMaestraDetalleEP_action}"
                                        reRender="contenidoFormulaMaestraVersionesEPDetalle">
                                            <h:graphicImage url="../img/organigrama3.jpg" alt="Detalle Empaque Primario"   />
                                        </a4j:commandLink>
                                        
                                    </h:column>
                                </rich:dataTable>
                                
                            </h:panelGroup>
                            <br/>
                            <%--
                            <a4j:commandButton  value="Terminar Producto" styleClass="btn"
                            onclick="javascript:Richfaces.showModalPanel('panelIngresoAcondicionamiento');javascript:Richfaces.hideModalPanel('panelActividadesProducto')" reRender="contenidoProgramaProduccion,contenidoIngresoAcondicionamiento" action="#{ManagedProgramaProduccion.terminarProductoConActividadesPendientes_action}"
                            ajaxSingle="false" status="statusPeticion" />
                            --%>
                            <input type="button" value="Aceptar" class="btn" onclick="javascript:Richfaces.hideModalPanel('panelFormulaMaestraVersionesEP')" />
                            </div>
                        </a4j:form>
                    </rich:modalPanel>


            <%-- empaque secundario --%>
                     <rich:modalPanel id="panelFormulaMaestraVersionesES" minHeight="420"
                                     minWidth="800" height="420" width="800" zindex="100"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto">
                        <f:facet name="header">
                            <h:outputText value="Empaque Secundario" />
                        </f:facet>
                        <a4j:form id="form6">
                            <div align="center">
                            <h:panelGroup id="contenidoFormulaMaestraVersionesES">

                            Empaque Secundario de: <h:outputText value="#{ManagedFormulaMaestraVersion.formulaMaestraSeleccionada.componentesProd.nombreProdSemiterminado}" />
                            <%--h:outputText value="#{areasdependientes.nombreAreaEmpresa}"   /--%>
                            <br><br>
                                <rich:dataTable value="#{ManagedFormulaMaestraVersion.formulaMaestraESList}" var="data" id="dataFormulaMaestraES"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedFormulaMaestraVersion.formulaMaestraESDataTable}">
                                    <h:column>
                                        <f:facet name="header">
                                            <h:outputText value=""  />

                                        </f:facet>
                                        <h:selectBooleanCheckbox value="#{data.checked}"  />
                                    </h:column>


                                    <h:column >
                                        <f:facet name="header">
                                            <h:outputText value="Presentacion Producto"  />
                                        </f:facet>
                                        <h:outputText value="#{data.presentacionesProducto.nombreProductoPresentacion}" />
                                    </h:column>
                                    <h:column >
                                        <f:facet name="header">
                                            <h:outputText value="Cantidad"  />
                                        </f:facet>
                                        <h:outputText value="#{data.presentacionesProducto.cantidadPresentacion}" />
                                    </h:column>
                                    <h:column>
                                        <f:facet name="header">
                                            <h:outputText value=""  />
                                        </f:facet>
                                        <a4j:commandLink onclick="javascript:Richfaces.showModalPanel('panelFormulaMaestraVersionesESDetalle');" action="#{ManagedFormulaMaestraVersion.verFormulaMaestraDetalleES_action}"
                                        reRender="contenidoFormulaMaestraVersionesESDetalle">
                                            <h:graphicImage url="../img/organigrama3.jpg" alt="Detalle Empaque Secundario"   />
                                        </a4j:commandLink>                                        
                                    </h:column>

                                </rich:dataTable>

                            </h:panelGroup>
                            <br/>
                            <%--
                            <a4j:commandButton  value="Terminar Producto" styleClass="btn"
                            onclick="javascript:Richfaces.showModalPanel('panelIngresoAcondicionamiento');javascript:Richfaces.hideModalPanel('panelActividadesProducto')" reRender="contenidoProgramaProduccion,contenidoIngresoAcondicionamiento" action="#{ManagedProgramaProduccion.terminarProductoConActividadesPendientes_action}"
                            ajaxSingle="false" status="statusPeticion" />
                            --%>
                            <input type="button" value="Aceptar" class="btn" onclick="javascript:Richfaces.hideModalPanel('panelFormulaMaestraVersionesES')" />
                            </div>
                        </a4j:form>
                    </rich:modalPanel>



                    <%-- detalle empaque primario --%>
                     <rich:modalPanel id="panelFormulaMaestraVersionesEPDetalle" minHeight="420"
                                     minWidth="800" height="420" width="800" zindex="100"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto">
                        <f:facet name="header">
                            <h:outputText value="Empaque Primario Detalle" />
                        </f:facet>
                        <a4j:form id="form7">
                            <div align="center">
                            <h:panelGroup id="contenidoFormulaMaestraVersionesEPDetalle">

                             de: <h:outputText value="#{ManagedFormulaMaestraVersion.formulaMaestraSeleccionada.componentesProd.nombreProdSemiterminado}" />
                            <%--h:outputText value="#{areasdependientes.nombreAreaEmpresa}"   /--%>
                            <br><br>
                                <rich:dataTable value="#{ManagedFormulaMaestraVersion.formulaMaestraDetalleEPList}" var="data" id="dataCliente"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';"
                                    headerClass="headerClassACliente">

                                    <h:column >
                                        <f:facet name="header">
                                            <h:outputText value="Material"  />
                                        </f:facet>
                                        <h:outputText value="#{data.materiales.nombreMaterial}" />
                                    </h:column>
                                    <h:column >
                                        <f:facet name="header">
                                            <h:outputText value="Cantidad"  />
                                        </f:facet>
                                        <h:outputText value="#{data.cantidad}" /><%-- onkeypress="valNum();" --%>
                                    </h:column>
                                    <h:column >
                                        <f:facet name="header">
                                            <h:outputText value="Unidad Medida"  />
                                        </f:facet>
                                        <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}" />
                                    </h:column>
                                </rich:dataTable>

                            </h:panelGroup>
                            <br/>
                            <%--
                            <a4j:commandButton  value="Terminar Producto" styleClass="btn"
                            onclick="javascript:Richfaces.showModalPanel('panelIngresoAcondicionamiento');javascript:Richfaces.hideModalPanel('panelActividadesProducto')" reRender="contenidoProgramaProduccion,contenidoIngresoAcondicionamiento" action="#{ManagedProgramaProduccion.terminarProductoConActividadesPendientes_action}"
                            ajaxSingle="false" status="statusPeticion" />
                            --%>
                            <input type="button" value="Aceptar" class="btn" onclick="javascript:Richfaces.hideModalPanel('panelFormulaMaestraVersionesEPDetalle')" />
                            </div>
                        </a4j:form>
                    </rich:modalPanel>
                    
                    
                    <%-- detalle empaque secundario --%>
                     <rich:modalPanel id="panelFormulaMaestraVersionesESDetalle" minHeight="420"
                                     minWidth="800" height="420" width="800" zindex="100"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto">
                        <f:facet name="header">
                            <h:outputText value="Empaque Secundario Detalle" />
                        </f:facet>
                        <a4j:form id="form8">
                            <div align="center">
                            <h:panelGroup id="contenidoFormulaMaestraVersionesESDetalle">

                             detalle Empaque Secundario de: <h:outputText value="#{ManagedFormulaMaestraVersion.formulaMaestraSeleccionada.componentesProd.nombreProdSemiterminado}" />
                            <%--h:outputText value="#{areasdependientes.nombreAreaEmpresa}"   /--%>
                            <br><br>
                                <rich:dataTable value="#{ManagedFormulaMaestraVersion.formulaMaestraDetalleESList}" var="data" id="dataFormulaMaestraDetalleES"
                                                onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                                onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                                headerClass="headerClassACliente">
                                    <h:column>
                                        <f:facet name="header">
                                            <h:outputText value=""  />

                                        </f:facet>
                                        <h:selectBooleanCheckbox value="#{data.checked}"  />
                                    </h:column>
                                    <h:column >
                                        <f:facet name="header">
                                            <h:outputText value="Empaque Secundario"  />
                                        </f:facet>
                                        <h:outputText value="#{data.materiales.nombreMaterial}" />
                                    </h:column>
                                    <h:column >
                                        <f:facet name="header">
                                            <h:outputText value="Cantidad"  />
                                        </f:facet>
                                        <h:outputText value="#{data.cantidad}" />
                                    </h:column>
                                    <h:column >
                                        <f:facet name="header">
                                            <h:outputText value="Unidad Medida"  />
                                        </f:facet>
                                        <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}" />
                                    </h:column>

                                </rich:dataTable>

                            </h:panelGroup>
                            <br/>
                            <%--
                            <a4j:commandButton  value="Terminar Producto" styleClass="btn"
                            onclick="javascript:Richfaces.showModalPanel('panelIngresoAcondicionamiento');javascript:Richfaces.hideModalPanel('panelActividadesProducto')" reRender="contenidoProgramaProduccion,contenidoIngresoAcondicionamiento" action="#{ManagedProgramaProduccion.terminarProductoConActividadesPendientes_action}"
                            ajaxSingle="false" status="statusPeticion" />
                            --%>
                            <input type="button" value="Aceptar" class="btn" onclick="javascript:Richfaces.hideModalPanel('panelFormulaMaestraVersionesESDetalle')" />
                            </div>
                        </a4j:form>
                    </rich:modalPanel>






                    


        </body>
    </html>
    
</f:view>

