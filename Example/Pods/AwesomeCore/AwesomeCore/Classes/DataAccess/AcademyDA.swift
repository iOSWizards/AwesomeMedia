//
//  AcademyDA.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 19/09/2017.
//

//import Foundation
//
//class AcademyDA {
//
//    func parseToCoreData(_ academy: ACAcademy) -> CDAcademy {
//
//        var cdAcademy: CDAcademy? = loadBy(academyId: academy.id)
//
//        if cdAcademy == nil {
//            cdAcademy = CDAcademy.newInstanceAC() as? CDAcademy
//        }
//
//        cdAcademy?.academyId = Int32(academy.id)
//        cdAcademy?.domain = academy.domain
//        cdAcademy?.name = academy.name
//        cdAcademy?.type = academy.type
//        cdAcademy?.subscription = academy.subscription
//        cdAcademy?.awcProductId = academy.awcProductId
//        cdAcademy?.themeColor = academy.themeColor
//        cdAcademy?.tribelearnTribeId = academy.tribeLearnTribeId
//        cdAcademy?.courseOrdering = academy.courseOrdering
//        cdAcademy?.authors = AuthorDA().extractAuthors(academy.authors)
//        cdAcademy?.numberOfCourses = Int16(academy.numberOfCourses)
//        cdAcademy?.featuredCourseId = Int32(academy.featuredCourseId)
//        cdAcademy?.coverPhotoUrl = academy.coverPhotoURL
//        cdAcademy?.courseCoverImages = academy.courseCoverImages
//        cdAcademy?.purchased = academy.purchased
//        cdAcademy?.purchasedAt = HelperDA.castToNSDate(academy.purchasedAt)
//
//        return cdAcademy!
//    }
//
//    func parseToCoreData(_ academy: ACAcademy, completion: @escaping (CDAcademy?)-> Void) {
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            var cdAcademy: CDAcademy? = self.loadBy(academyId: academy.id)
//
//            if cdAcademy == nil {
//                cdAcademy = CDAcademy.newInstanceAC() as? CDAcademy
//            }
//
//            cdAcademy?.academyId = Int32(academy.id)
//            cdAcademy?.domain = academy.domain
//            cdAcademy?.name = academy.name
//            cdAcademy?.type = academy.type
//            cdAcademy?.subscription = academy.subscription
//            cdAcademy?.awcProductId = academy.awcProductId
//            cdAcademy?.themeColor = academy.themeColor
//            cdAcademy?.tribelearnTribeId = academy.tribeLearnTribeId
//            cdAcademy?.courseOrdering = academy.courseOrdering
//            cdAcademy?.authors = AuthorDA().extractAuthors(academy.authors)
//            cdAcademy?.numberOfCourses = Int16(academy.numberOfCourses)
//            cdAcademy?.featuredCourseId = Int32(academy.featuredCourseId)
//            cdAcademy?.coverPhotoUrl = academy.coverPhotoURL
//            cdAcademy?.courseCoverImages = academy.courseCoverImages
//            cdAcademy?.purchased = academy.purchased
//            cdAcademy?.purchasedAt = HelperDA.castToNSDate(academy.purchasedAt)
//
//            completion(cdAcademy)
//        })
//    }
//
//    func parseFromCoreData(_ academy: CDAcademy) -> ACAcademy {
//        var courseCovers = [String]()
//        if let covers = academy.courseCoverImages {
//            courseCovers = covers
//        }
//        return ACAcademy(
//            id: Int(academy.academyId),
//            domain: academy.domain ?? "",
//            name: academy.name ?? "",
//            type: academy.type ?? "",
//            subscription: academy.subscription,
//            awcProductId: academy.awcProductId ?? "",
//            themeColor: academy.themeColor ?? "",
//            tribeLearnTribeId: academy.tribelearnTribeId ?? "",
//            courseOrdering: academy.courseOrdering ?? "",
//            authors: AuthorDA().extractCDAuthors(academy.authors),
//            numberOfCourses: Int(academy.numberOfCourses),
//            featuredCourseId: Int(academy.featuredCourseId),
//            coverPhotoURL: academy.coverPhotoUrl ?? "",
//            courseCoverImages: courseCovers,
//            purchased: academy.purchased,
//            purchasedAt: academy.purchasedAt as Date? ?? nil
//        )
//    }
//
//    // MARK: - Save
//
//    func saveSync(_ academy: ACAcademy) {
//        _ = parseToCoreData(academy)
//    }
//
//    func saveAcademy(_ academy: ACAcademy, completion: (() -> Void)? = nil) {
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            _ = self.parseToCoreData(academy)
//        },operationDone: {
//            completion?()
//        })
//    }
//
//    // MARK: - Search
//
//    func loadBy(academyId: Int) -> ACAcademy? {
//        let academy: CDAcademy? = loadBy(academyId: academyId)
//        guard  let coreDataObject = academy else {
//            return nil
//        }
//        return parseFromCoreData(coreDataObject)
//    }
//
//    func loadBy(academyId: Int) -> CDAcademy? {
//        let predicate = NSPredicate(format: "academyId == %d", academyId)
//        guard let cdCourse = CDAcademy.listAC(predicate: predicate).first as? CDAcademy else {
//            return nil
//        }
//        return cdCourse
//    }
//
//    func loadCDAcademyUsingBatch(academyId: Int, completion: @escaping (CDAcademy?) -> Void) {
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            let predicate = NSPredicate(format: "academyId == %d", academyId)
//            guard let academy = CDAcademy.listAC(predicate: predicate).first as? CDAcademy else {
//                completion(nil)
//                return
//            }
//            completion(academy)
//        })
//    }
//
//
//    // MARK: - Delete
//
//    func deleteAll() {
//        CDAcademy.deleteAllUsingBackgroundContext()
//    }
//
//}
