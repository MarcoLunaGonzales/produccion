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
                function getCodigoActividadProduccion(codigoFormulaMaestra,codAreaEmpresa){
                //   alert(codigo);
                   location='../actividades_formula_maestra/navegador_actividades_formula.jsf?codigo='+codigoFormulaMaestra+'&codAreaEmpresa='+codAreaEmpresa;
                }
                function getCodigoActividadMicrobiologia(codigoFormulaMaestra,codAreaEmpresa){
                //   alert(codigo);
                   location='../actividades_formula_maestra/navegador_actividades_formula.jsf?codigo='+codigoFormulaMaestra+'&codAreaEmpresa='+codAreaEmpresa;
                }
                function getCodigoActividadControlDeCalidad(codigoFormulaMaestra,codAreaEmpresa){
                //   alert(codigo);
                   location='../actividades_formula_maestra/navegador_actividades_formula.jsf?codigo='+codigoFormulaMaestra+'&codAreaEmpresa='+codAreaEmpresa;
                }
                function getCodigoActividadAcondicionamiento(codigoFormulaMaestra,codAreaEmpresa){
                //   alert(codigo);
                   location='../actividades_formula_maestra/navegador_actividades_formula.jsf?codigo='+codigoFormulaMaestra+'&codAreaEmpresa='+codAreaEmpresa;
                }
                function getCodigoFasePreparado(codigoFormulaMaestra){
                //   alert(codigo);
                   location='../formulaMaestraPreparado/navegadorFormulaMaestraPreparado.jsf?codigoFormulaMaestra='+codigoFormulaMaestra;
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
        <body>
            <h:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedFormulaMaestra.obtenerCodigo}"   />
                    <%--a4j:jsFunction action="#{ManagedFormulaMaestra.tiposProduccion_change}" name="cargarF" reRender="dataFormula" /--%>
                    <h:outputText styleClass="outputTextTitulo"  value="Listado de Formulas Maestras de Desarrollo" style="font-size:1.2em !important" />
                    <br><br>
                        <rich:panel  headerClass="headerClassACliente" style="width:70%">
                        <f:facet name="header">
                            <h:outputText value="Buscador"/>
                        </f:facet>
                        <h:panelGrid columns="6">
                            <h:outputText styleClass="outputTextBold"  value="Producto" />
                            <h:outputText styleClass="outputTextBold"  value="::" />
                            <h:inputText value="#{ManagedFormulaMaestra.formulaMaestrabean.componentesProd.nombreProdSemiterminado}" style="width:25em" styleClass="inputText"/>
                            <h:outputText styleClass="outputTextBold"  value="Estado" />
                            <h:outputText styleClass="outputTextBold"  value="::" />
                            <h:selectOneMenu value="#{ManagedFormulaMaestra.formulaMaestrabean.estadoRegistro.codEstadoRegistro}" styleClass="inputText">
                                <f:selectItems value="#{ManagedEstadosCompProd.estadosCompProd}"  />
                            </h:selectOneMenu>

                            <h:outputText styleClass="outputTextBold"  value="Area Fabricacion" />
                            <h:outputText styleClass="outputTextBold"  value="::" />
                            <h:selectOneMenu value="#{ManagedFormulaMaestra.formulaMaestrabean.componentesProd.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                                <f:selectItems value="#{ManagedFormulaMaestra.areasEmpresaList}"  />
                            </h:selectOneMenu>
                        </h:panelGrid>
                        <a4j:commandButton action="#{ManagedFormulaMaestra.buscarFormulaMaestra_action}" value="BUSCAR" styleClass="btn" reRender="dataFormula"/>
                    </rich:panel>
                    <br> <br>
                    <h:panelGroup id="contenidoFormula">
                    <rich:dataTable value="#{ManagedFormulaMaestra.formulaMaestraList}" var="data" id="dataFormula" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" binding="#{ManagedFormulaMaestra.formulaMaestraDataTable}">
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
                                <h:outputText value="Tipo Producción"  />
                            </f:facet>
                            <h:outputText value="#{data.componentesProd.tipoProduccion.nombreTipoProduccion}" />
                        </h:column>
                        
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value=" M P"  />
                            </f:facet>
                            <h:outputText value="<a  onclick=\"getCodigo('#{data.codFormulaMaestra}');\" style='cursor:hand;text-decoration:underline' ><img src='../img/organigrama3.jpg' alt='Materia Prima '></a>  "  escape="false"  />
                        </h:column>    
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Actividades"  />
                            </f:facet>
                            <h:commandLink action="#{ManagedFormulaMaestra.verActividadesFormulaMaestraDesarrollo_action}">
                                <h:graphicImage url="../img/organigrama3.jpg" />
                            </h:commandLink>
                        </h:column>  
                        <%--h:column rendered="#{ManagedFormulaMaestra.codAreaEmpresaPersonal eq '40'}">
                            <f:facet name="header">
                                <h:outputText value=" Reactivos"  />
                            </f:facet>
                            <h:outputText value="<a  onclick=\"getCodigoReactivo('#{data.codFormulaMaestra}');\" style='cursor:hand;text-decoration:underline' ><img src='../img/organigrama3.jpg' alt='Material Reactivo '></a>  "  escape="false"  />
                        </h:column--%>
                        
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="E P"  />
                            </f:facet>
                            <h:outputText value="<a  onclick=\"getCodigoArea('#{data.codFormulaMaestra}');\" style='cursor:hand;text-decoration:underline' ><img src='../img/organigrama3.jpg' alt='Empaque Primario'></a>  "  escape="false"  />
                        </h:column>
                        
                        
                    </rich:dataTable>
                    </h:panelGroup>
                    <br>
                    <h:commandButton value="Agregar"   styleClass="btn"  action="#{ManagedFormulaMaestra.actionagregar}" />
                    <h:commandButton value="Editar" type="submit"   styleClass="btn"  action="#{ManagedFormulaMaestra.actionEditar}" onclick="return editarItem('form1:dataFormula');" />
                    <a4j:commandButton value="Editar Estado" styleClass="btn"  action="#{ManagedFormulaMaestra.editarEstadoFormulaMaestra_action}" oncomplete="location='editar_estado_formula_maestra.jsf'" />
                    <a4j:commandButton value="Eliminar" styleClass="btn"  action="#{ManagedFormulaMaestra.eliminarFormulaMaestra}"  onclick="if(!eliminar('form1:dataFormula')){return false;}"  reRender="contenidoFormula"/>
                    <a4j:commandButton value="Crear Nuevo Tamaño de Lote"   styleClass="btn" action="#{ManagedFormulaMaestra.seleccionFormulaMaestraDuplicar}"  
                    onclick="if(!editarItem('form1:dataFormula')){return false;}"
                    oncomplete="Richfaces.showModalPanel('panelCrearNuevoTamanioLote')" reRender="contenidoCrearNuevoTamanioLote"/>
                    <%--h:commandButton value="Actualizar Programa Produccion" type="submit"  styleClass="btn"  action="#{ManagedFormulaMaestra.actualizarProductosProgramaProduccion_action}"  /><%--onclick="return eliminar('form1:dataFormula');">
                    <a4j:commandButton value="Guardar Version Actual" type="submit"  styleClass="btn"  action="#{ManagedFormulaMaestra.guardarVersionActual_action}" oncomplete="if(#{ManagedFormulaMaestra.mensaje!=''}){alert('#{ManagedFormulaMaestra.mensaje}');}" onclick="if(confirm('Desea guardar una copia de la version actual del producto seleccionado?')==false){return false;}" /><%--onclick="return eliminar('form1:dataFormula');"--%>
                    <rich:panel headerClass="headerClassACliente" rendered="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1738'|| ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '826' || ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1033'}">
                        <f:facet name="header">
                            <h:outputText value="Opciones Generales"/>
                        </f:facet>
                    
                    <a4j:commandButton styleClass="btn" value="Agregar Actividad General"  onclick="var a=Math.random();window.location='../formula_maestra/agregarActividadesGeneral.jsf?a='+a"/>
                    <a4j:commandButton styleClass="btn" value="Duplicar Actividades"  onclick="var b=Math.random();window.location='../formula_maestra/duplicarActividadesFormulaMaestra.jsf?b='+b"/>
                    <a4j:commandButton styleClass="btn" value="Asignar Horas Hombre/Maquina"  onclick="var b=Math.random();window.location='../formula_maestra/asignarHorasGeneral.jsf?b='+b"/>

                    <h:commandButton value="Horas Promedio Productos"  action="#{ManagedActividadesFormulaMaestra.actualizarTiemposProducto_action}" styleClass="btn"   />
                    <a4j:commandButton value="Copiar Materiales" action="#{ManagedFormulaMaestra.cargarFormulaMaestraCopia}" reRender="contenidoCopiaMaterialReactivo" oncomplete="Richfaces.showModalPanel('panelCopiaMaterialReactivo')" styleClass="btn" />

                    </rich:panel></div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFormulaMaestra.closeConnection}"  />
                
            </h:form>
            <rich:modalPanel id="panelCrearNuevoTamanioLote" minHeight="180"  minWidth="450"
                        height="180" width="450"  zindex="200"
                        headerClass="headerClassACliente"
                        resizeable="true" style="overflow:auto" >
                        <f:facet name="header">
                            <h:outputText value="<center>Crear Nuevo Tamaño de Lote</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="formDuplicar" >
                            <center>
                            <h:panelGroup id="contenidoCrearNuevoTamanioLote" style="align:center">
                                <h:panelGrid columns="3">
                                    <h:outputText value="Producto" styleClass="outputTextBold"/>
                                    <h:outputText value="::" styleClass="outputTextBold"/>
                                    <h:outputText value="#{ManagedFormulaMaestra.formulaMaestraDuplicarLote.componentesProd.nombreProdSemiterminado}" styleClass="outputText2"/>
                                    <h:outputText value="Tamaño Lote" styleClass="outputTextBold"/>
                                    <h:outputText value="::" styleClass="outputTextBold"/>
                                    <h:outputText value="#{ManagedFormulaMaestra.formulaMaestraDuplicarLote.cantidadLote}" styleClass="outputText2"/>
                                    <h:outputText value="Nuevo Tamaño Lote" styleClass="outputTextBold"/>
                                    <h:outputText value="::" styleClass="outputTextBold"/>
                                    <h:inputText value="#{ManagedFormulaMaestra.cantidadNuevoLote}" id="nuevaCantidad" onkeypress="valNum();" styleClass="inputText"/>
                                </h:panelGrid>

                            
                        </h:panelGroup>
                        
                        <div style="margin-top:1em">
                            <a4j:commandButton styleClass="btn" value="Guardar"  onclick="if(parseInt(document.getElementById('formDuplicar:nuevaCantidad').value)<=0){alert('Debe registrar una cantidad mayor a 0');return false;}"
                            action="#{ManagedFormulaMaestra.guardarCrearNuevoTamanioLoteFMDesarrollo}" oncomplete="if(#{ManagedFormulaMaestra.mensaje eq '1'}){alert('Se creo el nuevo tamaño de lote del producto');Richfaces.hideModalPanel('panelCrearNuevoTamanioLote');}
                            else{alert('#{ManagedFormulaMaestra.mensaje}')}" reRender="contenidoFormula"/>
                             <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelCrearNuevoTamanioLote')" class="btn" />
                        </div>
                        </center>


                        </a4j:form>
         </rich:modalPanel>
            
          <rich:modalPanel id="panelCopiaMaterialReactivo" minHeight="180"  minWidth="580"
                        height="180" width="580"  zindex="200"
                        headerClass="headerClassACliente"
                        resizeable="true" style="overflow:auto">
                        <f:facet name="header">
                            <h:outputText value="Copiar Material Reactivo"/>
                        </f:facet>
                        <a4j:form id="formCopiaMaterialReactivo">
                            <h:panelGroup id="contenidoCopiaMaterialReactivo">
                                <h:panelGrid columns="2">
                                    <h:outputText styleClass="outputText1"  value="Formula Maestra" />
                                    <h:outputText value="#{ManagedFormulaMaestra.formulaMaestraSeleccionado.componentesProd.nombreProdSemiterminado}" styleClass="outputText1" />
                                    
                                    <h:outputText value="producto Destino :" styleClass="outputTextTitulo" />
                                    <h:selectOneMenu value="#{ManagedFormulaMaestra.formulaMaestraCopia.codFormulaMaestra}" styleClass="inputText">
                                        <f:selectItems value="#{ManagedFormulaMaestra.formulaMaestraCopiaList}"/>
                                    </h:selectOneMenu>
                                </h:panelGrid>


                        </h:panelGroup>
                        <br/>
                        <div align="center">
                        <a4j:commandButton styleClass="btn" value="Copiar"
                        action="#{ManagedFormulaMaestra.copiarFormulaMaestra_action}"
                        oncomplete="Richfaces.hideModalPanel('panelCopiaMaterialReactivo')"
                        />
                        <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelCopiaMaterialReactivo')" class="btn" />

                        </div>
                        </a4j:form>
         </rich:modalPanel>
         <a4j:status id="statusPeticion"
                    onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                    onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
        </a4j:status>

        <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                         minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

            <div align="center">
                <h:graphicImage value="../img/load2.gif" />
            </div>
        </rich:modalPanel>
        </body>
    </html>
    
</f:view>

