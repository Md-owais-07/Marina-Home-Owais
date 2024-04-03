//
//  References.swift
//  Marina Home
//
//  Created by Mohammad Owais on 02/04/24.
//


//    func setupNotifications() {
//        notificationModel = [
//
//            NotificationDataModel(headerLabel: "10% OFF on your Initial Order",
//                                  middleLabel: "Shop and get 10% OFF on your very first order. Offer valid for your first after registration. Use code FIRST10 at checkout.",
//                                  isRead: false),
//            NotificationDataModel(headerLabel: "Complete your previous order",
//                                  middleLabel: "Lorem ipsum dolor sit amet, consetetur sadipscing.",
//                                  isRead: false),
//            NotificationDataModel(headerLabel: "Order Delivered",
//                                  middleLabel: "Order no. 123456 was delivered on Feb 16 to your address",
//                                  isRead: true)
//        ]
//        // By default, show all notifications
//        filteredNotifications = notificationModel
//    }

//        if (!filteredNotifications[indexPath.row].isRead) {
//            cell?.boldLabel.text = filteredNotifications[indexPath.row].headerLabel
//            cell?.boldLabel.font = .systemFont(ofSize: 13, weight: .bold)
//            cell?.roundView.isHidden = false
//            cell?.forwardButton.tintColor = .red
//        } else {
//            cell?.boldLabel.text = filteredNotifications[indexPath.row].headerLabel
//            cell?.boldLabel.font = .systemFont(ofSize: 13, weight: .regular)
//            cell?.roundView.isHidden = true
//            cell?.forwardButton.tintColor = .lightGray
//        }
//        cell?.regularLabel.text = filteredNotifications[indexPath.row].middleLabel
//
//        return cell!
