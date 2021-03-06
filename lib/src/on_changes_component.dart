import 'dart:convert';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

class Hero {
  String name;
  Hero(this.name);
  Map<String, dynamic> toJson() => {'name': name};
}

@Component(
  selector: 'on-changes',
  template: '''
    <div class="hero">
      <p>{{hero.name}} can {{power}}</p>

      <h4>-- Change Log --</h4>
      <div *ngFor="let chg of changeLog">{{chg}}</div>
    </div>
    ''',
  styles: [
    '.hero {background: LightYellow; padding: 8px; margin-top: 8px}',
    'p {background: Yellow; padding: 8px; margin-top: 8px}'
  ],
  directives: [coreDirectives],
)
class OnChangesComponent implements OnChanges {
  @Input()
  Hero hero;
  @Input()
  String power;

  List<String> changeLog = [];

  ngOnChanges(Map<String, SimpleChange> changes) {
    changes.forEach((String propName, SimpleChange change) {
      String cur = json.encode(change.currentValue);
      String prev = change.previousValue == null
          ? "{}"
          : json.encode(change.previousValue);
      changeLog.add('$propName: currentValue = $cur, previousValue = $prev');
    });
  }

  void reset() {
    changeLog.clear();
  }
}

@Component(
  selector: 'on-changes-parent',
  templateUrl: 'on_changes_parent_component.html',
  styles: ['.parent {background: Lavender}'],
  directives: [coreDirectives, formDirectives, OnChangesComponent],
)
class OnChangesParentComponent {
  Hero hero;
  String power;
  String title = 'OnChanges';
  @ViewChild(OnChangesComponent)
  OnChangesComponent childView;

  OnChangesParentComponent() {
    reset();
  }

  void reset() {
    // new Hero object every time; triggers onChange
    hero = Hero('Windstorm');
    // setting power only triggers onChange if this value is different
    power = 'sing';
    childView?.reset();
  }
}
