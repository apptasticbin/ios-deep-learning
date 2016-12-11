//
//  ProjectTableViewController.m
//  ios-deep-learning
//
//  Created by Bin Yu on 09/12/2016.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "ProjectTableViewController.h"
#import "Project.h"
#import "ProjectController.h"
#import "ProjectModel.h"
#import "UIStoryboard+Helper.h"

NSString * const ProjectTableViewControllerCellID           = @"ProjectTableViewCell";
NSString * const ProjectTableViewControllerStoryBoardID     = @"ProjectTableViewController";

@interface ProjectTableViewController ()

@property (nonatomic, strong) ProjectController *projectController;

@end

@implementation ProjectTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // we load projects if and only if being initialized from storyboard or xib
        _projectController = [ProjectController sharedController];
        _projects = _projectController.projects;
        self.title = @"Projects";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
}

#pragma mark - Private

- (void)navigateToChildProjects:(NSArray<ProjectModel *> *)projects groupName:(NSString *)groupName {
    ProjectTableViewController *vc = [UIStoryboard instantiateViewControllerInMainStoryboard:ProjectTableViewControllerStoryBoardID];
    vc.projects = projects;
    vc.title = groupName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navigateToProject:(Class)projectClass {
    UIViewController *vc = [projectClass projectViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProjectTableViewControllerCellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ProjectTableViewControllerCellID];
    }
    
    ProjectModel *project = self.projects[indexPath.row];
    cell.textLabel.text = project.name;
    cell.detailTextLabel.text = project.desc;
    cell.accessoryType = project.isLeaf ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITabieViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectModel *project = self.projects[indexPath.row];
    if (!project.isLeaf) {
        [self navigateToChildProjects:project.children groupName:project.name];
    } else {
        [self navigateToProject:project.projectClass];
    }
}

@end
