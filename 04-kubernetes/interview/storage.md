# Interview Questions — Storage

**Q1. What's the relationship between a Pod, a PVC, and a PV?**
Expected answer points:
- Pod references a PVC by name in its volume config.
- PVC is a request for storage, matched/bound to a PV that satisfies it.
- PV is the actual provisioned storage resource, independent of any
  specific Pod's lifecycle.

**Q2. Why doesn't deleting a Pod delete its persistent data?**
Expected answer points:
- The PVC (and underlying PV/storage) is a separate object from the Pod.
- A new Pod created afterward (e.g. by the same Deployment) mounts the
  *same* PVC and sees the same data.
- Data is only actually lost if the PVC is deleted *and* the PV's reclaim
  policy is `Delete`.

**Q3. What does a StorageClass do, and what is dynamic provisioning?**
Expected answer points:
- StorageClass defines *how* storage should be provisioned (which backend/
  provisioner, parameters).
- Dynamic provisioning means a PV is automatically created to satisfy a
  PVC, rather than a PV being manually pre-created.

**Q4. Why might a PVC stay in `Pending` state?**
Expected answer points:
- No PV available that satisfies size/access mode.
- `storageClassName` typo or references a StorageClass that doesn't exist.
- Provisioner failure or unavailable backend storage.
- Requested `accessMode` unsupported by the backend.

**Q5. What's the difference between an ephemeral Volume type (like
`emptyDir`) and a PVC-backed Volume?**
Expected answer points:
- `emptyDir` is tied to the Pod's lifecycle — genuinely gone when the Pod
  is deleted.
- A PVC-backed Volume persists independently of any one Pod's lifecycle.

**Q6. What reclaim policy would you use for a production database's PV,
and why?**
Expected answer points:
- `Retain` — so an accidental PVC deletion doesn't immediately destroy the
  underlying data, giving a chance to recover.
