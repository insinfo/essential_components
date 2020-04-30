### en-US

## essential_components
A library to simplify the life of web application developers with AngularDart. This library will implement several key components for the fast development of web applications with AngularDart.

## Components Gallery
[essential-components-gallery](https://essential-components-gallery.firebaseapp.com/)

## Getting Started

1\. Create a new AngularDart app: https://angulardart.dev/guide/setup

2\. Add `essential_components` to `pubspect.yaml`:

```yaml
dependencies:
    ...
    essential_components: any
    ...
```

3\. Add css stylesheet link on `theme.scss`:

```html
<head>
  @import "package:bootstrap_sass/scss/bootstrap";
  @import 'package:essential_components/scss/icomoon.scss';
  @import 'package:essential_components/scss/bootstrap.scss';
  @import 'package:essential_components/scss/bootstrap_limitless.scss';
  @import 'package:essential_components/scss/layout.scss';
  @import 'package:essential_components/scss/components.scss';
  @import 'package:essential_components/scss/colors.scss';
  @import 'package:essential_components/scss/fix.scss';
</head>
```

4\. Add needed `essential_components` directives to your components:

```dart
import 'package:essential_components/essential_components.dart';

@Component(
    // ...
    directives: const [
      EssentialToastComponent,
    EssentialDataTableComponent,
    EssentialDataTableComponent,
    EssentialSelectDialogComponent,
    MoneyMaskDirective,
    EssentialAccordionComponent,
    EsAccordionPanelComponent,
    EssentialModalComponent,
    EssentialDropdownDialogComponent,
    EssentialSimpleSelectComponent,
    TextMaskDirective,
    MoneyMaskDirective,
    AnoValidator,
    DateTimeValueAccessor,])
```
## Components

#### DataTable
#### Toast
#### SelectDialog
#### DropdownDialog
#### NotificationToast
#### Acordion
#### Modal
#### SimpleDialog
#### SimpleLoading 
#### SimpleCardModel
#### SimpleTabs
#### DynamicTabs
#### SimpleSelect
#### fontawesome
#### TimelineComponent
#### DatePickerComponent

## APIs to help

#### RestClient 
#### SimpleXlsx

## Directives

#### ano_validator
#### datetime_value_accessor
#### decimal_value_accessor
#### maxlength_directive
#### money_mask_directive
#### textmask_directive
#### validator_response
#### collapse
#### dropdown
#### button 

### Example DataTable

 in model class implement interface IDataTableRender to define fields that will be displayed in DataTable

```dart
import 'package:essential_components/essential_components.dart';
import 'dart:html' as html;

class User implements IDataTableRender {
  int id;
  String name;
  String username;
  String email;

  static List<String> status = ['active', 'inactive', 'canceled', 'paused'];

  User.fromJson(Map<String, dynamic> json) {
    try {
      id = json.containsKey("id") ? json['id'] : -1;
      name = json.containsKey("name") ? json['name'] : "";
    } catch (e) {
      print('User.fromJson: ${e}');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = Map<String, dynamic>();
    if (this.id != null) {
      json['id'] = this.id;
    }
    json['name'] = this.name;
  }

  @override
  DataTableRow getRowDefinition() {
    var settings = DataTableRow();
    settings.addSet(DataTableColumn(
        key: "name",
        value: name,
        title: "Name",
        customRender: (html.TableCellElement cellElement) {
          if (name == "Leanne Graham") {
            cellElement?.closest('tr')?.style?.background = "#e8fbee";
            return '''<span style="font-size: .8125rem;
    padding: 5px 15px; color: #fff; font-weight: 400;    
    border-radius: 10px; background: #2fa433d9;">
              $name</span>''';
          }
          return name;
        }));

    settings.addSet(DataTableColumn(key: "username", value: username, title: "username", limit: 20));
    return settings;
  }
}
```
In component import essential_components and set 
and define the methods and properties that will be used for DataTable to get and filter the data.

In this example below I am using the RestClientGeneric API to get the data, and SimpleLoadingComponent to show a loading animation.

```dart
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

//components
import 'package:essential_components/essential_components.dart';

//models
import 'src/models/user.dart';

import 'dart:html' as html;

@Component(
    selector: 'my-app',
    styleUrls: ['app_component.css'],
    templateUrl: 'app_component.html',
    directives: [
      formDirectives,
      coreDirectives,
      EssentialToastComponent,
      routerDirectives,
      EssentialDataTableComponent,
      MaxlengthDirective,
      esDynamicTabsDirectives,
      EssentialSimpleSelectComponent,
      EsSimpleSelectOptionComponent,
      EsDatePickerPopupComponent,
      EsDatePickerComponent
    ],
    exports: [User])
class AppComponent implements OnInit {
  RList<User> users;
  User selected;
  SimpleLoadingComponent loading;
  @ViewChild('dataTable')
  EssentialDataTableComponent dataTable;
  //rest client for get JSON data from backend
  RestClientGeneric rest;

  static EssentialNotificationService notificationService = EssentialNotificationService();

  @ViewChild('card')
  html.DivElement card;

  AppComponent() {
    loading = SimpleLoadingComponent();
    //init rest client for get JSON data from backend
    RestClientGeneric.basePath = ''; //example /api/v1/
    RestClientGeneric.host = "127.0.0.1";
    RestClientGeneric.protocol = UriMuProtoType.http;
    RestClientGeneric.port = 8080;
    rest = RestClientGeneric<User>(factories: {User: (x) => User.fromJson(x)});
  }

  @override
  void ngOnInit() async {
    //display loading animation on container div card
    loading.show(target: card);
    //loading data from server side REST API
    var resp = await rest.getAll('/mockdata.json', queryParameters: DataTableFilter().getParams());
    loading.hide();
    if (resp.status == RestStatus.SUCCESS) {
      users = resp.dataTypedList;
    } else {
      print(resp.message);
      print(resp.exception);
    }
  }

  //on click in row of dataTable
  void onRowClick(User selected) {
    this.selected = selected;
  }

  bool hasSeletedItems() {
    return dataTable.selectedItems != null && dataTable.selectedItems.isNotEmpty;
  }

  Future<void> onRequestData(DataTableFilter dataTableFilter) async {
    var resp = await rest.getAll('/user', queryParameters: dataTableFilter.getParams());
    if (resp.status == RestStatus.SUCCESS) {
      this.users = resp.dataTypedList;
    } else {
      dataTable.setErrorOccurred();
    }
  }

  Future<void> reloadTableOnChange(e) async {
    dataTable.reload();
  }

  onDelete() {
    SimpleDialogComponent.showConfirm("Are you sure you want to remove this item? The operation cannot be undone.",
        confirmAction: () {
      if (hasSeletedItems()) {
        AppComponent.notificationService.add('success', 'App', "Success");
      } else {
        AppComponent.notificationService.add('danger', 'App', "Select items");
      }
    });
  }
}

```
in template HTML

```html
<h1>DataTable Exemple</h1>
<div  #card class="card">
    <div style="padding: 15px;">
        <div class="row">
            <div class="col-md-6 text-truncate">              
                <span style="font-size: 1.0625rem;">Sample example DataTable</span>
            </div>           
            <div class="col-md-3 ">
                <div class="form-group">                 
                    <es-simple-select  displaytype="select" buttonText="Todos"
                        [options]="User.status" (change)="reloadTableOnChange($event)">
                        <es-simple-select-option [value]="null" selected>Todos</es-simple-select-option>
                    </es-simple-select>
                </div>
            </div>
           
            <div class="col-md-3 text-right">
                <button  type="button"
                    class="btn btn-primary legitRipple">Add</button>
                <button (click)="onDelete()" type="button" class="btn bg-pink-400 legitRipple"
                    [disabled]="!hasSeletedItems()">Delete</button>
            </div>
        </div>
    </div>

    <es-data-table #dataTable [data]="users" (rowClick)="onRowClick($event)" (dataRequest)="onRequestData($event)">
    </es-data-table>
</div>

<es-notification-outlet [service]='notificationService'></es-notification-outlet>
```

# pt-BR

## Essencials Components
Uma biblioteca para desenvolvedores AngularDart.
<i>Em construção</i>

## Instalação
1. Adicione a dependência em seu gerenciador de pacotes dentro do arquivo pubspec.yaml.
```yaml
dependencies:
  essential_components: ^0.1.2
```
2. Instale usando o comando `pub get`

3. Para usar basta importar a implementação dentro do seu componente:

```dart
import 'package:essential_components/essential_components.dart';
```

## Componentes presentes
- Datatable
- Select Dialog
- Notification
- Toast

## Como usar
É extremamente simples a forma de usar os componentes essenciais.

#### Datatable
O datatable é um componente que organiza as os dados que são consumidos em um serviço, onde o mesmo devem possuir um estrutura defina tanto para o request, quanto para o response dos dados.

A principio, existe uma estrutura de dados que é enviada como 'Query Params'. Esses dados são muito relevantes para a funcionalidade de filtros. Logo, o backend da aplicação deverá tratar esses dados caso o desenvolvedor queira realizar pesquisas baseados em filtros. Esses parâmetros são expressados na seguinte estrutura de dados:

```dart
int limit;
int offset;
String search;
String orderBy;
String orderDir;
```

Por padrão, ao contrário do backend da aplicação, o Datatable já possuí esses dados tratados no frontend (Dart), logo os filtros ocorrem automáticamente.

Agora que já estamos ciente do que é preciso para funcionar a base de filtragem, vamos direcionar o foco para a renderização do nosso Datatable.

##### Definiando o modelo de negócios

Para que o Datatable possa funcionar, o primeiro passo é implementar o modelo de negócio com a interface IDataTableRender. Por exemplo:

```dart
class Categoria implements IDataTableRender {
  int id;
  String nome;

  @override
  DataTableRow getRowDefinition() {
    DataTableRow settings = DataTableRow();
    settings.addSet(DataTableColumn(key: 'id', value: idAsString, title: 'Id'));
    settings.addSet(DataTableColumn(key: 'nome', value: nome, title: 'Nome'));
    return settings;
  }
}
```

A classe implementada sobrescreve um método que retorna um `DataTableRow`, chamado `getRowDefinition()`. Este método é respectivo a configuração de cabeçalho do Datatable. Onde é instanciado uma linha, e as colunas com o DataTableColumn. O DataTableColumn recebe alguns parâmetros pertinentes a sua configuração:
```dart
    class DataTableColumn {
        dynamic key;
        dynamic value;
        DataTableColumnType type;
        String title;
        int limit;
        String format;
        bool primaryDisplayValue;
    }
```
Vamos seguir o exemplo da nossa classe de categoria:

````dart
class Categoria implements IDataTableRender {
  int id;
  String nome;
}
```

```dart
dynamic key; //essa seria a chave. Ex.: 'nome'
dynamic value; //este seria o valor do campo. Ex: nome
DataTableColumnType type; // DataTableColumnType.text. Esses são os tipos presentes no Enum. Eles são: img, text, date, dateTime
String title; // 'Id'
int limit; //Limitar a quanidade de caracteres
String format; // Para alguns tipos existem uma formatação específica.
bool primaryDisplayValue; //Caso houver exibir uma unica coluna, qual a coluna vai ser exibida. Muito usada no select dialog.
```

Agora, o processo de renderização esta pré moldado para ser trabalhado dentro do seu componente angular dart.

Para isso, basta instanciar o componente referenciando a view.
```dart
@ViewChild('dataTable')
EssentialDataTableComponent dataTable;
```

Esta tabela emite alguns eventos. Entre os mais importantes, estão:
rowClick: Ao clicar, o objeto é retornado.
dataRequest: Pertinentes aos filtros a serem renderizados

o Inline da view do template, ficaria destacado da seguinte forma:

```html
<es-data-table
    #dataTable
    [data]="categorias"
    (rowClick)="onRowClick($event)"
    (dataRequest)="onRequestData($event)">
</es-data-table>
```

Os métodos onRowClient($event) e onRequestData($event), ambos precisam ser implementados no componente definindo lógicas de negócios.

Por exemplo... com o onRowClick($event), é possível navegar para outra página salvando uma refeerência de um objeto para realizar uma atualização de um objeto de dados.

```dart
    onRowClick(event) {
        this.categoria = event; //rebendo instancia do objeto categoria
        goToDetail();
    }
```

É preciso implementar o OnRequest data simplesmente para colher o filtro da tabela.
```dart
Future<void> onRequestData(DataTableFilter dataTableFilter) async {
    await getAllCampanhas(filters: dataTableFilter);
}
```