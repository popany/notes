# [System of record](https://en.wikipedia.org/wiki/System_of_record)

- [System of record](#system-of-record)

A **system of record** (**SOR**) or **source system of record** (**SSoR**) is a **data management term** for an information storage system (commonly implemented on a computer system running a database management system) that is the authoritative data source for a given data element or piece of information. The need to identify systems of record can become acute in organizations where management information systems have been built by taking output data from multiple source systems, re-processing this data, and then re-presenting the result for a new business use.

In these cases, multiple information systems may disagree about the same piece of information. These disagreements may stem from semantic differences, differences in opinion, use of different sources, differences in the timing of the extract, transform, load processes that create the data they report against, or may simply be the result of bugs.

The integrity and validity of any data set is open to question when there is no traceable connection to a good source, such as a known System of Record. Where the integrity of the data is vital, if there is an agreed system of record, the data element must either be linked to, or extracted directly from it. In other cases, the provenance and estimated data quality should be documented.

The "system of record" approach is a good fit for environments where both:

- there is a single authority over all data consumers, and
- all consumers have similar needs

In diverse environments, one instead needs to support the presence of multiple opinions. Consumers may accept different authorities or may differ on what constitutes an authoritative source -- researchers may prefer carefully vetted data, while tactical military systems may require the most recent credible report.
