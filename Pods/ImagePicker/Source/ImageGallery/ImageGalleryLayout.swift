import UIKit

class ImageGalleryLayout: UICollectionViewFlowLayout {

  let pickerConfiguration: PickerConfiguration

  init(pickerConfiguration: PickerConfiguration) {
    self.pickerConfiguration = pickerConfiguration
    super.init()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard let attributes = super.layoutAttributesForElements(in: rect) else {
      return super.layoutAttributesForElements(in: rect)
    }

    let newAttributes = attributes.map({ (attribute) -> UICollectionViewLayoutAttributes in
      // swiftlint:disable force_cast
      let newAttribute = attribute.copy() as! UICollectionViewLayoutAttributes
      newAttribute.transform = pickerConfiguration.rotationTransform
      return newAttribute
    })

    return newAttributes
  }
}
