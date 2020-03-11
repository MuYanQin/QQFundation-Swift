//
//  QQTabeViewManager.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/11.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit

class QQTabeViewManager: NSObject,UITableViewDelegate,UITableViewDataSource {
    var tableView = UITableView();
    open var registeredClasses = Dictionary<String, String>();
    var sections = Array<QQTableViewSection>();
    
    var allItems :Array<QQTableViewItem>?{
        get{
            var itemArray  = Array<QQTableViewItem>();
            for items in self.sections {
                itemArray.append(contentsOf: items.items!);
            }
            return itemArray;
        }
    }
    
    open func initWithTableView(tableView:UITableView) -> QQTabeViewManager {
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        return self;
    }
    //下标算法 自定义下标
    subscript(key :String) -> String{
        get {
            return self.registeredClasses[key]!;
        }
        set(obj) {
            self.registeredClasses[key] = obj
            registerClass(objectClass: key, forCellWithReuseIdentifier: obj , bundle: Bundle.main);
        }
    }
    
    //注册nib cell
    func registerClass(objectClass:String,forCellWithReuseIdentifier identifier:String,bundle:Bundle) -> Void {
        self.registeredClasses[objectClass] = identifier;
        if (bundle.path(forResource: identifier as String, ofType: "nib") != nil) {
            self.tableView.register(UINib.init(nibName: identifier , bundle: bundle), forCellReuseIdentifier: identifier);
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].items!.count;
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  item = self.sections[indexPath.section].items![indexPath.row]
        item.tableViewManager = self
        let identifier = String(describing: type(of: item))
        
        var projectName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String
        projectName = projectName!.replacingOccurrences(of: "-", with: "_")
        let className = projectName! + "." + self.registeredClasses[identifier]!
        
        let cellClass = NSClassFromString(className) as! QQTableViewCell.Type
        
        var cell  = tableView.dequeueReusableCell(withIdentifier: identifier) as? QQTableViewCell;
        if cell == nil {
            cell =  cellClass.init();
            cell!.cellDidLoad();
        }
        cell?.item = item;
        cell?.cellWillAppear();
        cell?.detailTextLabel?.text = nil;
        if item.cellHeight == 0  {
            item.cellHeight =  (cell?.autoCellHeight())!;
        }
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){

    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath){
        let tc  = cell as! QQTableViewCell
        tc.cellDidDisappear();
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.sections[indexPath.section].items![indexPath.row];
        return item.cellHeight == 0 ? 44 :item.cellHeight;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let item = self.sections[indexPath.section].items![indexPath.row]
        if (item.selcetCellHandler != nil) {
            item.selcetCellHandler!(item)
        }

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let item = self.sections[indexPath.section].items![indexPath.row]
        return item.allowSlide;
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = self.sections[indexPath.section].items![indexPath.row]
        return configAction(textArray: item.trailingTextArray, colorArray: item.trailingColorArray,item: item)
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = self.sections[indexPath.section].items![indexPath.row]
        return configAction(textArray: item.leadingTextArray, colorArray: item.leadingColorArray,item: item)
    }
    @available(iOS 11.0, *)
    func configAction(textArray : Array<String>,colorArray :Array<UIColor>,item :QQTableViewItem) -> UISwipeActionsConfiguration {
        var actions = Array<UIContextualAction>();
        if textArray.count>0 {
              for(index,value) in textArray.enumerated(){
                  let rowAct = UIContextualAction(style: .normal, title: value) {
                      (action, view, completionHandler) in
                        if (item.trailingSwipeHandler != nil) {
                            item.trailingSwipeHandler!(item,index)
                        }
                      completionHandler(true)
                  }
                  if colorArray.count > index {
                      rowAct.backgroundColor = colorArray[index]
                  }else{
                      rowAct.backgroundColor = UIColor.red;
                }
                actions.append(rowAct)
              }
          }
        let configuration = UISwipeActionsConfiguration(actions: actions)
        return configuration
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions = Array<UITableViewRowAction>();
        let item = self.sections[indexPath.section].items![indexPath.row]
        if item.trailingTextArray.count>0 {
            for(index,value) in item.trailingTextArray.enumerated(){
                let rowAct = UITableViewRowAction.init(style: .destructive, title: value) { (action, indexPath) in
                    if (item.trailingSwipeHandler != nil) {
                        item.trailingSwipeHandler!(item,index)
                    }
                }
                if item.trailingColorArray.count > index {
                    rowAct.backgroundColor = item.trailingColorArray[index]
                }else{
                    rowAct.backgroundColor = UIColor.red;
                }
                
                actions.append(rowAct);
            }
        }
        return actions
    }
    
    //MARk -- 索引相关
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.sections.count < section {
            return nil;
        }
        let sec = self.sections[section];
        return sec.sectionTitle as String;
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var titles =  Array<String>();
        for section in self.sections {
            if section.indexTitle != nil {
                titles.append(section.indexTitle!)
            }
        }
        return titles;
    }
    
    func reloadDataFromArray(sections: Array<QQTableViewSection>) -> Void {
        self.sections .removeAll()
        for section in sections {
            section.tableViewManager = self
        }
        self.sections.append(contentsOf: sections)
        self.tableView .reloadData();
    }
}
