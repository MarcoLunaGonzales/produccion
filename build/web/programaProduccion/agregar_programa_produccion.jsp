<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    
    <html>
        <head>
            <title></title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script type="text/javascript" src="../js/general.js" ></script> 
            <script>
                function validar(){
                    
                   var compronenteProd=document.getElementById('form1:compronenteProd');
                   var codTipoProgramaProduccion=document.getElementById('form1:codTipoProgramaProduccion');
                   var cantidadProduccion = document.getElementById('form1:cant_lote');
                   var nroLotes = document.getElementById('form1:nroLotes');
                   
                   if(compronenteProd.value=='0'){
                     alert('Por favor Seleccione un producto para su formula maestra.');
                     compronenteProd.focus();
                     return false;
                   }

                   if(codTipoProgramaProduccion.value==0){
                     alert('Por favor Seleccione el tipo de Programa de Produccion.');
                     codTipoProgramaProduccion.focus();
                     return false;
                   }
                   if(cantidadProduccion.value<=0){
                       alert('La cantidad de lote de produccion debe ser mayor a cero');
                       cantidadProduccion.focus();
                       return false;
                   }
                   if(nroLotes.value<=0){
                       alert('El numero de lotes debe ser mayor a cero');
                       nroLotes.focus();
                       return false;
                   }



                   return true;
                }
              
 
  
function validarFecha(){   
    //alert();
    var nombre=document.getElementById('form1:f_inicio');
    var Fecha= new String(nombre.value)   //Crea un string 
    var RealFecha= new Date()   //Para sacar la fecha de hoy   
    //Cadena Año   
    var Ano= new String(Fecha.substring(Fecha.lastIndexOf("/")+1,Fecha.length))   
    //Cadena Mes   
    var Mes= new String(Fecha.substring(Fecha.indexOf("/")+1,Fecha.lastIndexOf("/")))   
    //Cadena Día   
    var Dia= new String(Fecha.substring(0,Fecha.indexOf("/")))   
    //alert(Ano);
    //alert(Mes);
    //alert(Dia);
    //Valido el año   
    if (isNaN(Ano) || Ano.length<4 || parseFloat(Ano)<1900){   
            alert('Año inválido');
            nombre.focus();
        return false   
    }   
    //Valido el Mes   
    if (isNaN(Mes) || parseFloat(Mes)<1 || parseFloat(Mes)>12){   
        alert('Mes inválido')  ;
        nombre.focus();
        return false   
    }   
    //Valido el Dia   
    if (isNaN(Dia) || parseInt(Dia, 10)<1 || parseInt(Dia, 10)>31){   
        alert('Día inválido') ;
        nombre.focus();
        return false   
    }   
    if (Mes==4 || Mes==6 || Mes==9 || Mes==11 || Mes==2) {   
        if (Mes==2 && Dia > 28 || Dia>30) {   
            alert('Día inválido') ;
            nombre.focus();
            return false   
        }   
    }  
    //alert('2');
    var nombre1=document.getElementById('form1:f_final');
    var Fecha1= new String(nombre1.value)   //Crea un string 
    //var RealFecha= new Date()   //Para sacar la fecha de hoy   
    //Cadena Año   
    var Ano1= new String(Fecha1.substring(Fecha1.lastIndexOf("/")+1,Fecha1.length))   
    //Cadena Mes   
    var Mes1= new String(Fecha1.substring(Fecha1.indexOf("/")+1,Fecha1.lastIndexOf("/")))   
    //Cadena Día   
    var Dia1= new String(Fecha1.substring(0,Fecha1.indexOf("/")))   
    //alert(Ano1);
    //alert(Mes1);
    //alert(Dia1);
    //Valido el año   
    if (isNaN(Ano1) || Ano1.length<4 || parseFloat(Ano1)<1900){   
            alert('Año inválido')   ;
            nombre1.focus();
        return false   
    }   
    //Valido el Mes   
    if (isNaN(Mes1) || parseFloat(Mes1)<1 || parseFloat(Mes1)>12){   
        alert('Mes inválido');
        nombre1.focus();
        return false   
    }   
    //Valido el Dia   
    if (isNaN(Dia1) || parseInt(Dia1, 10)<1 || parseInt(Dia1, 10)>31){   
        alert('Día inválido');
        nombre1.focus();
        return false   
    }   
    if (Mes1==4 || Mes1==6 || Mes1==9 || Mes1==11 || Mes1==2) {   
        if (Mes1==2 && Dia1 > 28 || Dia1>30) {   
            alert('Día inválido');
            nombre1.focus();
            return false   
        }   
    }   
       
  //para que envie los datos, quitar las  2 lineas siguientes   
  //alert("Fecha correcta.")   
  return true     
}  
            </script>
        </head>
        <body >
            <h:form id="form1"  >
                
                <div align="center">
                    <br><br>
                        <a4j:commandLink value="Seleccionar Programa Produccion" onclick="Richfaces.showModalPanel('panelSeleccionarProducto')">

                        </a4j:commandLink>
                        <rich:dataTable value="#{ManagedProgramaProduccion.programaProduccionProductosList}"
                                    var="data" id="dataProgramaProduccionProductos"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"                                    
                                     >



                                     <rich:column  >
                                        <f:facet name="header">
                                            <h:outputText value="Producto"  />
                                        </f:facet>
                                        <h:outputText value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
                                    </rich:column>
                                    <rich:column  >
                                        <f:facet name="header">
                                            <h:outputText value="Cantidad de Lote"  />
                                        </f:facet>
                                        <h:outputText value="#{data.cantidadLote}"  />
                                    </rich:column>                                  
                                    <rich:column  >
                                        <f:facet name="header">
                                            <h:outputText value="Nro de Lote"  />
                                        </f:facet>
                                        <h:outputText value="#{data.codLoteProduccion}"  />
                                    </rich:column >                                   
                                    <rich:column   >
                                        <f:facet name="header">
                                            <h:outputText value="Tipo Programa Producción"  />
                                        </f:facet>
                                        <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}" />
                                    </rich:column >

                                    <rich:column  >
                                        <f:facet name="header" >
                                            <h:outputText value="Area"  />
                                        </f:facet>
                                        <h:outputText value="#{data.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}"/>
                                    </rich:column>
                                  
                                    <rich:column   >
                                        <f:facet name="header">
                                            <h:outputText value="Estado"  />
                                        </f:facet>
                                        <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}" />
                                    </rich:column >

                       </rich:dataTable>

                    <h:panelGrid columns="3" id="contenidoProgramaProduccion" styleClass="panelgrid" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Registrar Programa Producción" styleClass="outputText2" style="color:#FFFFFF"   />
                        </f:facet>      
                        
                        <h:outputText styleClass="outputText2" value="Formula Maestra"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu  styleClass="inputText" value="#{ManagedProgramaProduccion.programaProduccionbean.formulaMaestra.codFormulaMaestra}"
                                          id="compronenteProd">
                            <f:selectItems value="#{ManagedProgramaProduccion.formulaMaestraList}"/>
                            <a4j:support action="#{ManagedProgramaProduccion.formulaMaestra_change}"  event="onchange"  reRender="contenidoProgramaProduccion,cant_lote,dataFormulaMP,dataFormulaEP,dataFormulaES,dataFormulaMPROM,empaque_prim,empaque_sec"  />
                        </h:selectOneMenu>
                        
                        

                        <h:outputText  styleClass="outputText2" value="Lote"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText styleClass="inputText" value="#{ManagedProgramaProduccion.programaProduccionbean.codLoteProduccion}" readonly="true" >
                            <a4j:support event="onchange" reRender="dataFormulaMP,dataFormulaEP,dataFormulaES,dataFormulaMPROM"  />
                        </h:inputText>


                        <h:outputText  styleClass="outputText2" value="Cantidad Lote Produccion"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText styleClass="inputText" value="#{ManagedProgramaProduccion.programaProduccionbean.cantidadLote}" 
                              id="cant_lote" onkeypress="valNum();"
                             >
                                 <a4j:support action="#{ManagedProgramaProduccion.cantidadLoteProduccion_change}"
                                               event="onblur" reRender="dataFormulaMP,dataFormulaEP,dataFormulaES,dataFormulaMPROM,dataFormulaMR"
                                               oncomplete="if(#{ManagedProgramaProduccion.mensaje!=''}){alert('#{ManagedProgramaProduccion.mensaje}');document.getElementById('form1:cant_lote').focus()}"
                                               />
                            <a4j:support event="onchange" reRender="cant_lote,dataFormulaMP,dataFormulaEP,dataFormulaES,dataFormulaMPROM,contenidoProgramaProduccion"  />
                        </h:inputText>



                        <h:outputText  styleClass="outputText2" value="Nro.Lotes a Producir"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText styleClass="inputText" value="#{ManagedProgramaProduccion.programaProduccionbean.nroLotes}"
                            id="nroLotes" onkeypress="valNum();" >
                                <a4j:support action="#{ManagedProgramaProduccion.cantidadLoteProduccion_change}"
                                               event="onblur" reRender="dataFormulaMP,dataFormulaEP,dataFormulaES,dataFormulaMPROM,dataFormulaMR,contenidoProgramaProduccion"
                                               oncomplete="if(#{ManagedProgramaProduccion.mensaje!=''}){alert('#{ManagedProgramaProduccion.mensaje}');document.getElementById('form1:nroLotes').focus() }"    />
                        </h:inputText>        
                        
                        <h:outputText styleClass="outputText2" value="Tipo Programa Producción"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu  styleClass="inputText" value="#{ManagedProgramaProduccion.programaProduccionbean.tiposProgramaProduccion.codTipoProgramaProd}" id="codTipoProgramaProduccion">
                            <f:selectItems value="#{ManagedProgramaProduccion.tiposProgramaProdList}"/>
                        </h:selectOneMenu>

                        <h:outputText  styleClass="outputText2" value="Observación"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputTextarea styleClass="inputText" value="#{ManagedProgramaProduccion.programaProduccionbean.observacion}" id="obs"  />
                        
                    </h:panelGrid>
                    
                    <br>
                    <b> Materia Prima </b>
                    <br>
                    
                    <rich:dataTable value="#{ManagedProgramaProduccion.formulaMaestraMPList}" var="data" id="dataFormulaMP" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" width="50%">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Material"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidad}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"  />
                        </h:column>
                        
                    </rich:dataTable>
                    <br>
                    <b> 
                    <h:outputText styleClass="outputText2" value="Empaque Primario"  /> </b>
                    <h:selectOneMenu id="empaque_prim" styleClass="inputText" value="#{ManagedProgramaProduccion.codPresPrim}"
                     valueChangeListener="#{ManagedProgramaProduccion.changeEventPrim}">    
                        <f:selectItems value="#{ManagedProgramaProduccion.empaquePrimarioList}"/>
                        <a4j:support event="onchange"  reRender="dataFormulaEP"  />
                    </h:selectOneMenu>
                    <br>
                    <rich:dataTable value="#{ManagedProgramaProduccion.formulaMaestraEPList}" var="data" id="dataFormulaEP" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" width="50%">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Material"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidad}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"  />
                        </h:column>
                        
                        
                    </rich:dataTable>
                    <br>
                    <b> 
                    <h:outputText styleClass="outputText2" value="Empaque Secundario"  /> </b>
                    <br>
                    <h:selectOneMenu id="empaque_sec" styleClass="inputText" value="#{ManagedProgramaProduccion.codPresProd}"
                    valueChangeListener="#{ManagedProgramaProduccion.changeEventSec}">
                        <f:selectItems value="#{ManagedProgramaProduccion.empaqueSecundarioList}"/>
                        <a4j:support event="onchange"  reRender="dataFormulaES"  />
                    </h:selectOneMenu>
                    <br>
                    <rich:dataTable value="#{ManagedProgramaProduccion.formulaMaestraESList}" var="data" id="dataFormulaES" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" width="50%">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Material"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidad}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"  />
                        </h:column>
                        
                        
                    </rich:dataTable>
                    <br>
                    <%--b> Material Promocional </b>
                    <br>
                    <rich:dataTable value="#{ManagedProgramaProduccion.formulaMaestraMPROMList}" var="data" id="dataFormulaMPROM" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" width="50%">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Material"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidad}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"  />
                        </h:column>
                        
                    </rich:dataTable--%>
                    <br />
                    <h:outputText value="fecha de Lote::" styleClass="outputText2" />
                    <h:panelGroup>
                    <h:inputText value="#{ManagedProgramaProduccion.fechaLote}"   styleClass="inputText"  id="fechaLote"  size="15" onblur="valFecha(this);" >
                             <f:convertDateTime pattern="dd/MM/yyyy"   />
                    </h:inputText>
                    <h:graphicImage url="../img/fecha.bmp"  id="imagenFecha2" />
                    <h:outputText value="<DLCALENDAR tool_tip='Seleccione la Fecha'  daybar_style='background-color: DBE1E7;font-family: verdana; color:000000;'    navbar_style='background-color: 7992B7; color:ffffff;'  input_element_id='form1:fechaLote' click_element_id='form1:imagenFecha2'></DLCALENDAR>"  escape="false"  />
                    </h:panelGroup>
                    <br />
                    
                    <a4j:commandButton value="Guardar" styleClass="btn"  action="#{ManagedProgramaProduccion.guardarProgramaProduccion_action}"  oncomplete="if(#{ManagedProgramaProduccion.mensaje!=''}){alert('#{ManagedProgramaProduccion.mensaje}')}else{location = 'navegador_programa_produccion.jsf'}"  onclick="return validar();" />
                    <h:commandButton value="Cancelar" styleClass="btn"   action="#{ManagedProgramaProduccion.cancelarAgregarProgramaProduccion_action}"/>
                    
                </div>
                
                
            </h:form>
            
            <rich:modalPanel id="panelSeleccionarProducto" minHeight="300"  minWidth="600"
                                     height="300" width="600"  zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Seleccionar Producto"/>
                        </f:facet>
                        <a4j:form id="form2">
                            <h:panelGroup id="contenidoSeleccionarProducto">
                            <div align="center">
                                  <rich:dataTable value="#{ManagedProgramaProduccion.programaProduccionLotesList}"
                                  var="data" id="dataFormula"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedProgramaProduccion.programaProduccionLotesDataTable}"
                                     >
                                       

                                        <h:column>
                                            <f:facet name="header">
                                                <h:outputText value="Producto"  />
                                            </f:facet>
                                            <a4j:commandLink value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"
                                            onclick="Richfaces.hideModalPanel('panelSeleccionarProducto')"
                                            reRender="dataProgramaProduccionProductos,contenidoProgramaProduccion,dataFormulaMP,dataFormulaEP,dataFormulaES"
                                            action="#{ManagedProgramaProduccion.seleccionarProgramaProduccionLotes_action}"
                                            >
                                            </a4j:commandLink>
                                        </h:column>
                                    

                                        <h:column>
                                            <f:facet name="header">
                                                <h:outputText value="Lote"  />
                                            </f:facet>
                                            <h:outputText value="#{data.codLoteProduccion}"  />
                                        </h:column>

                                        <h:column>
                                            <f:facet name="header">
                                                <h:outputText value="Categoría"  />
                                            </f:facet>
                                            <h:outputText value="#{data.formulaMaestra.componentesProd.categoriasCompProd.nombreCategoriaCompProd}"  />
                                        </h:column>


                                        <h:column >
                                            <f:facet name="header">
                                                <h:outputText value="Estado"  />
                                            </f:facet>
                                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}" />
                                        </h:column>
                                </rich:dataTable>                              
                        
                        <br/>

                        <a4j:commandButton styleClass="btn" value="Registrar" onclick="if(validarAsignacionCintasSeguridad('form2:listadoSeleccionarProducto')){Richfaces.showModalPanel('panelIngresosDetalleAcond');}"  action="#{ManagedCintasSeguridad.seleccionarIngresoAcondicionamiento_action}"
                                           reRender="contenidoIngresosDetalleAcond" />
                        <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelSeleccionarProducto')" class="btn" />
                        </div>
                        </h:panelGroup>
                        </a4j:form>
                </rich:modalPanel>


        </body>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        
    </html>
    
</f:view>

