//
//  QQTableViewManager.swift
//  QQFundation-Swift
//
//  Created by leaduMac on 2020/3/11.
//  Copyright © 2020 leaduadmin. All rights reserved.
//

import UIKit

class QQTableViewManager: NSObject,UITableViewDelegate,UITableViewDataSource {
    
    /// 被管理的视图
    var tableView : QQTableView?
    
    /// 数据源里面存储所有的section
    var sections = Array<QQTableViewSection>();
    
    
    /// 获取全部的items
    var allItems :Array<QQTableViewItem>{
        get{
            var itemArray  = Array<QQTableViewItem>();
            for items in self.sections {
                itemArray.append(contentsOf: items.items);
            }
            return itemArray;
        }
    }
    init(tableView:QQTableView){
        super.init()
        tableView.delegate = self;
        tableView.dataSource = self;
        self.tableView = tableView;
    }
    //下标算法 自定义下标
    /*subscript(key :String) -> Any{
        get {
        }
        set(obj) {
        }
    }*/
    
    //MARK: - 操作cell的视图
    
    /// 插入sectoin并刷新
    /// - Parameters:
    ///   - section: section
    ///   - index: 下标
    /// - Returns: 无
    func insertSection(_ section:QQTableViewSection, _ index:Int) -> Void {
        self.sections.insert(section, at: index)
        self.tableView?.performBatchUpdates({
            self.tableView?.insertSections(IndexSet(integer: index), with: .none)
        })
    }
    
    /// 移除一个section
    /// - Parameter index: 下标
    /// - Returns: 无
    func removeSection( _ index:Int) -> Void {
        self.sections.remove(at: index)
        self.tableView?.performBatchUpdates({
            self.tableView?.deleteSections(IndexSet(integer: index), with: .none)
        })
    }
    
    //MARK: - cell相关
    
    //注册 cell
    func register(cellClass :AnyClass ,itemClass: AnyClass) -> Void {
        
        guard let tableView = self.tableView else { return  }
        let bundle = Bundle.main
        
        //判断是以Cell结尾的则是UItableViewCell的注册 反之则是HeaderFooter注册
        if "\(cellClass)".hasSuffix("Cell"){
            //这里判断是不是nib初始化的
            if (bundle.path(forResource: "\(cellClass)", ofType: "nib") != nil) {
                tableView.register(UINib.init(nibName: "\(cellClass)" , bundle: bundle), forCellReuseIdentifier: "\(itemClass)");
            }else{
                tableView.register(cellClass, forCellReuseIdentifier: "\(itemClass)")
            }
            
        }else{
            if (bundle.path(forResource: "\(cellClass)", ofType: "nib") != nil){
                
                tableView.register(UINib.init(nibName: "\(cellClass)" , bundle: bundle), forHeaderFooterViewReuseIdentifier: "\(itemClass)")
                                   
            }else{
                tableView.register(cellClass, forHeaderFooterViewReuseIdentifier: "\(itemClass)")
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].items.count;
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  item = self.sections[indexPath.section].items[indexPath.row]
        item.tableViewManager = self
        let identifier = String(describing: type(of: item))
        let cell  = tableView.dequeueReusableCell(withIdentifier: identifier) as? QQTableViewCell;
        cell?.item = item;
        cell?.cellWillAppear();
        cell?.detailTextLabel?.text = nil;
        if item.cellHeight == 0  {
            item.cellHeight =  cell?.autoCellHeight() ?? 0
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
        let item = self.sections[indexPath.section].items[indexPath.row];
        return item.cellHeight == 0 ? 44 :item.cellHeight;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let item = self.sections[indexPath.section].items[indexPath.row]
        if (item.selectCellHandler != nil) {
            item.selectCellHandler!(item)
        }

    }
    //MARk -- headView相关
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sec = self.sections[section];
        if sec.item?.secHeight != nil {
            return sec.item!.secHeight!;
        }
        if sec.sectionHeight != nil {
            return sec.sectionHeight!;
        }
        if sec.sectionTitle != nil {
            return 30;
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sec = self.sections[section];
        if (sec.item == nil){
            return nil;
        }
        let identifier = NSStringFromClass(object_getClass(sec.item)!).components(separatedBy: ".").last
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier!) as? QQTableViewSecView
        view?.item = sec.item;
        return view;
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if view.isKind(of: QQTableViewSecView.self){
            let tv =  view as! QQTableViewSecView;
            tv.secViewWillAppear()
        }
        
    }
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if view.isKind(of: QQTableViewSecView.self){
            let tv =  view as! QQTableViewSecView;
            tv.secViewDidDisappear()
        }
    }
    //MARk -- 侧滑相关
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let item = self.sections[indexPath.section].items[indexPath.row]
        return item.allowSlide;
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = self.sections[indexPath.section].items[indexPath.row]
        return configAction(textArray: item.trailingTArray, colorArray: item.trailingCArray,item: item,trailing: true)
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = self.sections[indexPath.section].items[indexPath.row]
        return configAction(textArray: item.leadingTArray, colorArray: item.leadingCArray,item: item,trailing: false)
    }
    @available(iOS 11.0, *)
    func configAction(textArray : Array<String>,colorArray :Array<UIColor>,item :QQTableViewItem,trailing :Bool) -> UISwipeActionsConfiguration {
        var actions = Array<UIContextualAction>();
        if textArray.count>0 {
              for(index,value) in textArray.enumerated(){
                  let rowAct = UIContextualAction(style: .normal, title: value) {
                      (action, view, completionHandler) in
                        if trailing{
                            if (item.trailingSwipeHandler != nil) {
                                item.trailingSwipeHandler!(item,index)
                            }
                        }else{
                            if (item.leadingSwipeHandler != nil) {
                                item.leadingSwipeHandler!(item,index)
                            }
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
        let item = self.sections[indexPath.section].items[indexPath.row]
        if item.trailingTArray.count>0 {
            for(index,value) in item.trailingTArray.enumerated(){
                let rowAct = UITableViewRowAction.init(style: .destructive, title: value) { (action, indexPath) in
                    if (item.trailingSwipeHandler != nil) {
                        item.trailingSwipeHandler!(item,index)
                    }
                }
                if item.trailingCArray.count > index {
                    rowAct.backgroundColor = item.trailingCArray[index]
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
        return sec.sectionTitle;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView!.scrollViewDidScroll != nil{
            self.tableView!.scrollViewDidScroll!(self.tableView!)
        }
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
        self.tableView!.reloadData();
    }
}
