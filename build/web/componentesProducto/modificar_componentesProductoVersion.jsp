<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
<html>
<head>
    <title>SISTEMA</title>
    <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    <script type="text/javascript" src="../js/general.js"></script>
    <script>
                function validar(nametable){
                    
                    var producto=document.getElementById('form1:producto');
                    var productosFormasFar=document.getElementById('form1:productosFormasFar');
                    var envasePrimario=document.getElementById('form1:envasePrimario');
                    var areaFabricacion=document.getElementById('form1:areaFabricacion');
                   
                    if(producto.value==0){
                        alert("El campo Nombre Comercial está vacio.");
                        producto.focus();
                        return false;
                    }
                    if(document.getElementById("form1:regSanitario").value==''){
                        alert("El registro sanitario esta vacio");
                        document.getElementById("form1:regSanitario").focus();
                        return false;
                    }
                    if(document.getElementById("form1:fechaVencRS").value==''){
                        alert("fecha de vencimiento RS esta vacio");
                        document.getElementById("form1:fechaVencRS").focus();
                        return false;
                    }
                    if(document.getElementById("form1:vidaUtil").value==''){
                        alert("La vida util esta vacio");
                        document.getElementById("form1:vidaUtil").focus();
                        return false;
                    }
                    /*   if(productosFormasFar.value==0){
                             alert("El campo Forma Farmaceútica está vacio.");
                             productosFormasFar.focus();
                             return false;
                           }
                           if(envasePrimario.value==0){
                             alert("El campo Envase Primario está vacio.");
                             envasePrimario.focus();
                             return false;
                           }
                           if(areaFabricacion.value==0)
                           {  alert("El campo Área de Fabricación está vacio.");
                              areaFabricacion.focus();
                              return false;
                           }*/
                    /* var elements=document.getElementById(nametable);
                           var rowsElement=elements.rows;
                                      
                           if(rowsElement.length==1){
                                alert("No existe ningún Principio Activo registrado.");
                                return false;
                           }
                           for(var i=1;i<rowsElement.length;i++){
                            var cellsElement=rowsElement[i].cells;
                            var cel_0=cellsElement[1];
                            var cel_1=cellsElement[2];
                            var data1=cel_0.getElementsByTagName('SPAN')[0].innerHTML;
                            var data2=cel_1.getElementsByTagName('input')[0].value;
                                if(data1=='' || data1==' '){
                                    alert("El campo Principio Activo se encuentra vacío.");
                                    return false;
                                }
                                if(data2==''){
                                    alert("El campo Concentración se encuentra vacío.");
                                    return false;
                                }
                           }*/
                    return true;
                }
                  
                function visibilityPanel(){
                    document.getElementById('form1:panelBuscar').style.visibility='hidden';
                }
                function formarNombre(){
                       
                    var nombreProducto=document.getElementById('form1:producto');
                    var nombreProductoSem=nombreProducto.options[nombreProducto.selectedIndex].text;
                    var productosFormasFar=document.getElementById('form1:productosFormasFar');
                    var nombreProductoSem1=productosFormasFar.options[productosFormasFar.selectedIndex].text;
                    //var cantidadPeso=document.getElementById('form1:volumenPesoPresentacion');
                    //alert(cantidadPeso.value);
                    var nombreProductoSemiterminado=document.getElementById('form1:nombreProductoSemiterminado');
                    nombreProductoSemiterminado.value=nombreProductoSem+" "+nombreProductoSem1;//+" "+cantidadPeso.value;
                
                }
                function generarConcentracion()
                {
                    var tabla=document.getElementById("form1:dataMaterialesConcentracion");
                    var concentracion="";
                    for(var i=1;i<tabla.rows.length;i++)
                    {
                        if(tabla.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                        {
                            var select=tabla.rows[i].cells[3].getElementsByTagName("select")[0];
                            concentracion+=(concentracion==""?"":",")+tabla.rows[i].cells[1].getElementsByTagName("span")[0].innerHTML+
                                            " "+tabla.rows[i].cells[2].getElementsByTagName("input")[0].value+" "+
                                            (parseInt(select.value)>0?select.options[select.selectedIndex].innerHTML:"");
                        }
                    }
                    document.getElementById("form1:concentracionProducto").innerHTML=concentracion+"/"+document.getElementById("form1:unidadMedidadProducto").value;
                }
                function generarConcentracionActivado(input)
                {
                    if(input.parentNode.parentNode.cells[0].getElementsByTagName("input")[0].checked){
                        generarConcentracion();
                    }
                }
                                    </script>
</head>
<body onload="carga();visibilityPanel();">
    
    <a4j:form id="form1"  >
        <div style="text-align:center">
        
        <a4j:region id="regionUno">
            <rich:panel id="panelBuscar" styleClass="panelBuscar" headerClass="headerClassACliente"
                        style="top:100px;left:150px;"
            >
                <f:facet name="header">
                    <h:outputText value="<div   onmouseover=\"this.style.cursor='move'\" onmousedown=\"comienzoMovimiento(event, 'form1:panelBuscar');\"  >Buscar<div   style=\"margin-left:550px;\"   onclick=\"closePanelBuscar();\" onmouseover=\"this.style.cursor='hand'\"   >Cerrar</div> </div> "
                                  escape="false" />
                </f:facet>
                
                
                <h:panelGrid columns="2" headerClass="headerClassACliente" width="50%">
                    <f:facet name="header">
                        <h:outputText value="Acción Terapeútica"  styleClass="tituloCampo"/>
                    </f:facet>
                    <h:inputText value="#{ManagedComponentesProducto.accionTerapeutica}" onkeypress="valMAY();"   styleClass="inputText"
                                 size="50" id="principioBuscar"  valueChangeListener="#{ManagedComponentesProducto.buscarAccionesTerapeuticas}">
                        <a4j:support  event="onkeyup"  reRender="resultadoBuscarProducto"  />
                    </h:inputText>
                    
                    
                </h:panelGrid>
                <rich:dataTable  value="#{ManagedComponentesProducto.resultado}"
                                 width="100%"  var="data" style="width:50%"
                                 onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                 onRowMouseOver="this.style.backgroundColor='#CCDFFA';"
                                 id="resultadoBuscarProducto" headerClass="headerClassACliente">
                    <f:facet name="header">
                        <rich:columnGroup>
                            <rich:column>
                                <h:outputText value="Nombre"  />
                            </rich:column>
                        </rich:columnGroup>
                    </f:facet>
                    
                    
                    <rich:column >
                        <a4j:commandLink  onclick="document.getElementById('form1:panelBuscar').style.visibility='hidden';document.getElementById('panelsuper').style.visibility='hidden';"
                                          actionListener="#{ManagedComponentesProducto.cogerCodigo}"   reRender="detalle">
                            <h:outputText value="#{data.nombre_accion_terapeutica} "  />
                            
                        </a4j:commandLink>
                    </rich:column>
                </rich:dataTable>
                
            </rich:panel>
            
            <!--buscar producto-->



            <div align="center">
                <h:outputText value="Editar Producto Semiterminado" styleClass="outputText2" style="font-weight:bold;font-size:14;" />
                <h:panelGrid columns="4" styleClass="panelgrid" headerClass="headerClassACliente" style="width:70%;border:1px solid #cccccc">
                    <f:facet name="header" >
                        <h:outputText value="Introduzca  Datos" styleClass="outputText2"    />
                    </f:facet>
                    
                    <h:outputText value="Nombre Comercial" styleClass="outputText2" style="font-weight:bold" />
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:selectOneMenu  styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.producto.codProducto}" id="producto" onchange="formarNombre();"
                    disabled="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal != '1195'}">
                        <f:selectItems value="#{ManagedComponentesProducto.productosList}"  />
                    </h:selectOneMenu>
                    <h:outputText  styleClass="outputText2"  value=""/>
                    
                    
                    <h:outputText value="Forma Farmaceútica" styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.forma.codForma}" id="productosFormasFar"
                    disabled="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal != '1195'}"><%-- onchange="formarNombre();" --%>
                        <f:selectItems value="#{ManagedComponentesProducto.productosFormasFarList}"  />
                    </h:selectOneMenu>
                    <h:outputText  styleClass="outputText2"  value=""/>
                    <h:outputText value="Via Administración" styleClass="outputText2" style="font-weight:bold" />
                            <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.viasAdministracionProducto.codViaAdministracionProducto}"
                            disabled="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1195'}">
                                <f:selectItems value="#{ManagedComponentesProducto.viasAdministracionSelectList}"  />
                            </h:selectOneMenu>
                    <h:outputText  styleClass="outputText2"  value=""/>
                    
                    <%--h:outputText value="Envase Primario " styleClass="outputText2" />
                                <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.envasesPrimarios.codEnvasePrim}" id="envasePrimario">
                                    <f:selectItems value="#{ManagedComponentesProducto.envasesPrimariosList}"  />
                                </h:selectOneMenu>
                                <h:outputText  styleClass="outputText2"  value=""/--%>

                    <%--h:outputText value="Volúmen/Concentración" styleClass="outputText2" />
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:inputText styleClass="inputText" size="35" onkeypress="valMAY();" value="#{ManagedComponentesProducto.componentesProdbean.volumenPesoEnvasePrim}"  id="volumenPesoPresentacion" onchange="formarNombre();"/>
                    <h:outputText  styleClass="outputText2"  value=""/--%>

                    <h:outputText value="Volúmen Envase Primario" styleClass="outputText2" style="font-weight:bold" />
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <%--h:inputText styleClass="inputText" size="35" onkeypress="valMAY();" value="#{ManagedComponentesProducto.componentesProdbean.volumenEnvasePrimario}"  id="volumenEnvasePrimario" /--%>
                    <h:panelGroup>
                        <h:inputText onkeypress="valNum();" styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.cantidadVolumen}"
                        disabled="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1195'}"/>
                        <h:selectOneMenu style='margin-left:8px;' value="#{ManagedComponentesProducto.componentesProdbean.unidadMedidaVolumen.codUnidadMedida}" styleClass="inputText"
                        disabled="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1195'}">
                            <f:selectItems value="#{ManagedComponentesProducto.unidadesMedidadSelectList}"/>
                        </h:selectOneMenu>
                    </h:panelGroup>
                    <h:outputText  styleClass="outputText2"  value=""/>
                    <h:outputText value="Tolerancia Volumen a fabricar" styleClass="outputText2"  style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:inputText onkeypress="valNum();" styleClass="inputText" size="35"  value="#{ManagedComponentesProducto.componentesProdbean.toleranciaVolumenfabricar}"
                    disabled="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1195'}"/>
                    <h:outputText  styleClass="outputText2"  value=""/>

                    <h:outputText value="Concentración " styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="#{ManagedComponentesProducto.componentesProdbean.concentracionEnvasePrimario}" id="concentracionProducto"/>
                    <h:outputText  styleClass="outputText2"  value=""/>
                    
                    <h:outputText value="Peso Envase Primario" styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:inputText styleClass="inputText" size="35" onkeypress="valNum();" value="#{ManagedComponentesProducto.componentesProdbean.pesoEnvasePrimario}"  id="pesoEnvasePrimario"
                    disabled="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1195'}"/>
                    <h:outputText  styleClass="outputText2"  value=""/>
                    <h:outputText value="Color Presentación Primaria" styleClass="outputText2" style="font-weight:bold"  />
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.coloresPresentacion.codColor}" id="coloresPresentacion"
                    disabled="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1195'}">
                        <f:selectItems value="#{ManagedComponentesProducto.coloresProductoList}"  />
                    </h:selectOneMenu>
                    <h:outputText  styleClass="outputText2"  value=""/>
                    
                    <h:outputText value="Sabor" styleClass="outputText2" style="font-weight:bold" />
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.saboresProductos.codSabor}" id="saboresProducto"
                    disabled="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal != '1195'}" >
                        <f:selectItems value="#{ManagedComponentesProducto.saboresProductoList}"  />
                    </h:selectOneMenu>
                    <h:outputText  styleClass="outputText2"  value=""/>
                    
                    <h:outputText value="Área de Fabricación" styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.areasEmpresa.codAreaEmpresa}" id="areaFabricacion"
                    disabled="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1195'}">
                        <f:selectItems value="#{ManagedComponentesProducto.areasEmpresaList}"  />
                    </h:selectOneMenu>
                    <h:outputText  styleClass="outputText2"  value=""/>
                    
                    <h:outputText value="Nombre Producto Semiterminado" styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:inputText styleClass="inputText" size="50" onkeypress="valMAY();" value="#{ManagedComponentesProducto.componentesProdbean.nombreProdSemiterminado}"  id="nombreProductoSemiterminado"
                    disabled="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1195'}"/>
                    <h:outputText  styleClass="outputText2"  value=""/>
                    
                    
                    <h:outputText value="Nombre Genérico" styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:inputText styleClass="inputText" size="50" value="#{ManagedComponentesProducto.componentesProdbean.nombreGenerico}"  id="nombreGenerico"
                    disabled="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal != '1195'}"/>
                    <h:outputText  styleClass="outputText2"  value=""/>
                    
                            <h:outputText value="Registro Sanitario" styleClass="outputText2"  style="font-weight:bold"/>
                            <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                            <h:inputText styleClass="inputText" disabled="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal != '1195'}" size="50" value="#{ManagedComponentesProducto.componentesProdbean.regSanitario}"  id="regSanitario" />
                            <h:outputText  styleClass="outputText2"  value=""/>

                            <h:outputText value="Fecha de Vencimiento R.S." styleClass="outputText2"  style="font-weight:bold"/>
                            <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                            <h:panelGroup>
                                <h:inputText disabled="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal != '1195'}" value="#{ManagedComponentesProducto.componentesProdbean.fechaVencimientoRS}"   styleClass="outputText2"  id="fechaVencRS"  size="15" onblur="valFecha(this);" >
                                    <f:convertDateTime pattern="dd/MM/yyyy"   />
                                </h:inputText>
                                <h:graphicImage url="../img/fecha.bmp"  id="imagenFecha1" rendered="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal != '1195'}" />
                                <h:outputText value="<DLCALENDAR tool_tip=\"Seleccione la Fecha\"  daybar_style=\"background-color: DBE1E7;font-family: verdana; color:000000;\"    navbar_style=\"background-color: 7992B7; color:ffffff;\"  input_element_id=\"form1:fechaVencRS\" click_element_id=\"form1:imagenFecha1\"></DLCALENDAR>"  escape="false"  />
                            </h:panelGroup>
                            <h:outputText  styleClass="outputText2"  value=""/>

                            <h:outputText value="Vida Útil (Meses)" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                            <h:inputText disabled="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal != '1195'}" styleClass="inputText" size="50" onkeypress="valNum();" value="#{ManagedComponentesProducto.componentesProdbean.vidaUtil}"  id="vidaUtil" />
                            <h:outputText  styleClass="outputText2"  value=""/>

                            

                    <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.estadoCompProd.codEstadoCompProd}" id="estado"
                    disabled="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1195'}">
                        <f:selectItems value="#{ManagedComponentesProducto.estadosCompProdList}"  />
                    </h:selectOneMenu>
                    <h:outputText  styleClass="outputText2"  value=""/>
                    <h:outputText value="Presentaciones Primarias" styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:panelGroup>
                        <a4j:repeat value="#{ManagedComponentesProducto.presentacionesProducto}" var="data">
                        <h:outputText  styleClass="outputText2"  value="#{data}" style=""/><br/>
                    </a4j:repeat>
                    </h:panelGroup>
                    <h:outputText  styleClass="outputText2"  value=""/>
                    <%--h:outputText value="Tipo Producción" styleClass="outputText2"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:selectOneMenu value="#{ManagedComponentesProducto.componentesProdbean.tipoProduccion.codTipoProduccion}" styleClass="inputText">
                        <f:selectItems value="#{ManagedComponentesProducto.tiposProduccionList}"/>
                    </h:selectOneMenu--%>
                    <h:outputText value="Produccion" styleClass="outputText2" style="font-weight:bold" />
                    <h:outputText  styleClass="outputText2"  value="::"/>
                    <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.tipoProduccion.codTipoProduccion}" id="codTipoProduccion"
                    disabled="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1195'}">
                        <f:selectItems value="#{ManagedComponentesProducto.tiposProduccionList}"  />
                    </h:selectOneMenu>
                    <h:outputText  styleClass="outputText2"  value=""/>
                    
                </h:panelGrid>
                <h:outputText value="<table style='border:1px solid #cccccc'><tr><td class='headerClassACliente' align='center'><span style='font-weight:bold;'>Concentracion del Producto</span></td></tr>
                <tr><td align='center'><span class='outputText2'>Concentracion Para:</span>" rendered="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1195'}" escape="false"/>
                
                             <h:inputText value="#{ManagedComponentesProducto.componentesProdConcentracionRegistrar.unidadProducto}" rendered="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1195'}" styleClass="inputText" id="unidadMedidadProducto" onkeyup="generarConcentracion();"/>
                <h:outputText value="</td></tr><tr><td><div style='height:20em;overflow:auto;width:100%'>" rendered="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1195'}" escape="false"/>

                         
                        <rich:dataTable value="#{ManagedComponentesProducto.componentesProdConcentracionList}" var="data" id="dataMaterialesConcentracion"
                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" rendered="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1195'}"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente" columnClasses="tituloCampo">
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}" onclick="generarConcentracion();" />
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText style="font-weight:bold" value="Material"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}" styleClass="outputText2"/>
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText style="font-weight:bold" value="Cantidad"/>
                            </f:facet>
                            <h:inputText value="#{data.cantidad}" onkeyup="generarConcentracionActivado(this);" styleClass="inputText"/>
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText style="font-weight:bold" value="Unidad Medida"/>
                            </f:facet>
                            <h:selectOneMenu onchange="generarConcentracionActivado(this);" value="#{data.unidadesMedida.codUnidadMedida}" styleClass="inputText">
                                <f:selectItems value="#{ManagedComponentesProducto.unidadesMedidadSelectList}"/>
                            </h:selectOneMenu>
                        </rich:column >
                        <rich:column >
                                    <f:facet name="header">
                                        <h:outputText style="font-weight:bold" value="Material Equivalencia"/>
                                    </f:facet>
                                    <h:inputText value="#{data.nombreMaterialEquivalencia}" styleClass="inputText"/>
                                </rich:column >
                                <rich:column >
                                    <f:facet name="header">
                                        <h:outputText style="font-weight:bold" value="Cantidad Equivalencia"/>
                                    </f:facet>
                                    <h:inputText value="#{data.cantidadEquivalencia}" styleClass="inputText"/>
                                </rich:column >
                                <rich:column >
                                    <f:facet name="header">
                                        <h:outputText style="font-weight:bold" value="Unidad Medida"/>
                                    </f:facet>
                                    <h:selectOneMenu  value="#{data.unidadMedidaEquivalencia.codUnidadMedida}" styleClass="inputText">
                                        <f:selectItems value="#{ManagedComponentesProducto.unidadesMedidadSelectList}"/>
                                    </h:selectOneMenu>
                                </rich:column >
                        </rich:dataTable>
                <h:outputText value="</div></td></tr></table>" rendered="#{ManagedAccesoSistema.usuarioModuloBean.codUsuarioGlobal eq '1195'}" escape="false"/>
                        
                <%--rich:panel  style="width:70%;border:1px solid #cccccc"  styleClass="panelgrid" headerClass="headerClassACliente" >
                    <f:facet name="header">
                        <h:outputText value="Acciones Terapeúticas" styleClass="outputText2" />
                    </f:facet>
                    
                    <h:panelGroup style="tex-align:left">
                        <a4j:commandLink action="#{ManagedComponentesProducto.mas}" reRender="detalle" accesskey="q" >
                            <h:graphicImage url="../img/mas.png" alt="mas"  style="border:0px solid red;"/>
                        </a4j:commandLink>
                        <a4j:commandLink action="#{ManagedComponentesProducto.menos}" reRender="detalle" accesskey="w" >
                            <h:graphicImage url="../img/menos.png"  alt="menos"  style="border:0px solid red;"/>
                        </a4j:commandLink>
                    </h:panelGroup>
                    <h:panelGrid columns="1" width="100%">
                        <rich:dataTable value="#{ManagedComponentesProducto.detalleList}" var="data" id="detalle" width="100%"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                        headerClass="headerClassACliente"
                                        columnClasses="tituloCampo">
                            
                            <f:facet name="header">
                                <rich:columnGroup >
                                    <rich:column>
                                        <h:outputText value="Buscar" styleClass="tituloCampo" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Acción Terapeútica" styleClass="tituloCampo" />
                                    </rich:column>
                                    
                                    
                                </rich:columnGroup>
                            </f:facet>
                            <h:column>
                                <a4j:commandLink data="#{data.codTemp}"
                                                 onclick="document.getElementById('form1:panelBuscar').style.visibility='visible';document.getElementById('panelsuper').style.visibility='visible';" actionListener="#{ManagedComponentesProducto.cogerId}" accesskey="b">
                                    <h:graphicImage url="../img/lupa.png"  style="border:0px solid red;" />
                                </a4j:commandLink>
                            </h:column>
                            
                            <h:column>
                                <h:outputText value="#{data.accionesTerapeuticas.nombreAccionTerapeutica} " styleClass="tituloCampo" />
                            </h:column>
                        </rich:dataTable>
                    </h:panelGrid>
                </rich:panel--%>
                <br>
                <h:commandButton value="Guardar" styleClass="btn" action="#{ManagedComponentesProducto.modificarComponentesProdversion1}" onclick="return validar('form1:detalle');" />
                <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="location= '#{ManagedComponentesProducto.direccion}'" /><%-- navegador_componentesProductoVersion.jsf --%>
            </div>
        </a4j:region>
    </a4j:form>
    </div>
    <h:panelGroup   id="panelsuper"  styleClass="panelSuper" style="visibility:hidden" >
    </h:panelGroup>
    <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js" ></script>
</body>
</html>

</f:view>



